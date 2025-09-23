const fs = require("fs")
const execSync = require("child_process").execSync

let traceFiles = ["bzip", "gcc", "sixpack", "swim"]
let algorithms = ["lru", "fifo", "rand", "clock"]

function runTest(file, algorithm, nFrames) {
    let result = execSync(`./memsim report-traces/${file}.trace ${nFrames} ${algorithm} quiet`)
    let lines = result.toString().split("\n").map(line => {
        return line.split(":").map(y => y.trim())
    })
    let pageFaultRateLine = lines.find(line => {
        return line[0] == "page fault rate"
    })
    let pageFaultRate = parseFloat(pageFaultRateLine[1])
    return pageFaultRate
}

function runFrameTest(file, algorithm) {
    let dataOut = {}
    for (let i=4; i<=128; i+=4) {
        let pageFaultRate = runTest(file, algorithm, i)
        // let pageFaultRate = 0.1
        dataOut[i] = pageFaultRate
        console.log(file, algorithm, i, pageFaultRate)
    }

    return dataOut
}

function runFullBench() {
    let benchResults = {}

    traceFiles.forEach(file => {
        let fileResults = {}
        algorithms.forEach(algorithm => {
            let testResults = runFrameTest(file, algorithm)
            fileResults[algorithm] = testResults
        })

        benchResults[file] = fileResults
    })

    return benchResults
}

function convertToCSV(fullBench) {
    csvFilesOut = {}
    traceFiles.forEach(file => {
        csvOut = file + "," + Object.keys(fullBench[file][algorithms[0]]).join(",") + "\n"

        algorithms.forEach(algorithm => {
            csvOut += algorithm + "," + Object.values(fullBench[file][algorithm]).join(",") + "\n"
        })

        csvFilesOut[file] = csvOut
    })

    return csvFilesOut
}

function exportCSV(csvData) {
    traceFiles.forEach(file => {
        fs.writeFileSync(`report-output/${file}.csv`, csvData[file])
    })
}

let fullBench = runFullBench()
let csv = convertToCSV(fullBench)
exportCSV(csv)
