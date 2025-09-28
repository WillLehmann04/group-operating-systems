const fs = require("fs")

const files = ["bzip", "gcc", "sixpack", "swim"]

function getPageTally(file) {
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

function getTallyMetrics(tally) {
    // get all entries as array
    let entries = Object.entries(tally)

    // get total number of hits
    let totalHits = 0
    entries.forEach(entry => {
        totalHits += entry[1]
    })

    console.log(totalHits)

    // sort by number of hits
    entries.sort((a,b) => {
        return b[1] - a[1]
    })

    // for each page, calculate percentage of hits
    entries.map(entry => {
        let percent = (entry[1] / totalHits) * 100
        entry.push(percent)
    })

    // calculate 50%, 75%, 90%, 95% metrics
    let percentCounted = 0
    let p50 = 0
    let p75 = 0
    let p90 = 0
    let p95 = 0
    
    entries.forEach((entry, entryIndex) => {
        percentCounted += entry[2]
        if (percentCounted<=50) { p50 = entryIndex+2 }
        if (percentCounted<=75) { p75 = entryIndex+2 }
        if (percentCounted<=90) { p90 = entryIndex+2 }
        if (percentCounted<=95) { p95 = entryIndex+2 }
    })
    
    return {p50, p75, p90, p95}
}

function testAllFiles() {
    let dataOut = {}
    files.forEach(file => {
        let tally = getPageTally(file)
        let metrics = getTallyMetrics(tally)
        dataOut[file] = metrics
    })
    return dataOut
}

console.table(testAllFiles())