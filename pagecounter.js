const fs = require("fs")

let files = ["bzip", "gcc", "sixpack", "swim"]

function testFile(file) {
    // get lines from file
    const path = `report-traces/${file}.trace`
    const lines = fs.readFileSync(path).toString().split("\n")

    let pages = new Set()

    // process each line
    lines.forEach((line, lineIndex) => {
        if (line.length==0) return

        let [address, operation] = line.split(" ")
        address = parseInt(address, 16) // convert to int
        let page = address >> 12 // get page no

        pages.add(page)
    })

    return pages.size
}

function testAllFiles() {
    dataOut = []
    files.forEach(file => {
        let uniquePages = testFile(file)
        let size = (uniquePages * 4) + " KBytes"
        dataOut.push({ file, uniquePages, size})
    })
    return dataOut
}

let allData = testAllFiles()
console.table(allData)