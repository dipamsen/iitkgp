#set page(flipped: true)

#let mat = json("../timetable/sem01/index.json").timeTableSlotMatrix

#let lunchAfterPeriod = int((mat.lunchStartTime - mat.firstPeriodStartTime) / 100)

#let getTime(start) = {
  // start = 800 => 8:00 AM to 8:55 PM
  let hour = int(start / 100)
  let minute = calc.rem(start, 100)
  let startTime = datetime(hour: hour, minute: minute, second: 0)
  let endTime = datetime(hour: hour, minute: minute + 55, second: 0)
  [
    #startTime.display("[hour repr:12]:[minute] [period]") - #endTime.display("[hour repr:12]:[minute] [period]")
  ]
}

#let days = ("monday", "tuesday", "wednesday", "thursday", "friday", "saturday")

#table(
  align: horizon + center,
  columns: (auto,) + (1fr,) * lunchAfterPeriod + (auto,) + (1fr,) * (mat.numPeriods - lunchAfterPeriod),
  table.header([Period], ..for i in range(lunchAfterPeriod) {
    ([#(i + 1)],)
  }, [], ..for i in range(lunchAfterPeriod, mat.numPeriods) {
    ([#(i + 1)],)
  }),
  [Time],
  ..for i in range(lunchAfterPeriod) {
    ([#getTime(mat.firstPeriodStartTime + i * 100)],)
  },
  table.cell(rowspan: 7)[Lunch],
  ..for i in range(lunchAfterPeriod, mat.numPeriods) {
    ([#getTime(mat.firstPeriodStartTime + i * 100 + 100)],)
  },
  ..for day in days {
    (upper(day), ..for i in range(mat.numPeriods) {
      let slots = mat.days.at(day).at(i)
      ([#slots.join("\n")],)
    })
  },
)
