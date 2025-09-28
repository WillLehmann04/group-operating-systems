const fs = require("fs")

const files = ["bzip", "gcc", "sixpack", "swim"]

function testFile(file) {
    const path = `report-traces/${file}.trace`
    const lines = fs.readFileSync(path).toString().split("\n")

    let tally = {}

    lines.forEach((line, lineIndex) => {
        if (line.length==0) return

        let [address, operation] = line.split(" ")
        address = parseInt(address, 16) // convert to int
        let page = address >> 12 // get page no
        page = page.toString(16) // convert back to hex

        if (tally[page] == null) {
            tally[page] = 0
        }

        tally[page]++
    })

    return tally
}

function tallyToCSV(tally) {
    let csvOut = 'page,count\n'
    Object.entries(tally).forEach(([page, count]) => {
        csvOut += `${page},${count}\n`
    })

    return csvOut
}

function testAllFiles() {
    files.forEach(file => {
        let tally = testFile(file)
        let csv = tallyToCSV(tally)
        fs.writeFileSync(`./report-pagetally/${file}.csv`, csv)
    })
}

testAllFiles()