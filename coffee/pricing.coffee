#moment = require('moment')
_ = require('lodash')

# Timing start
startDt = new Date().getTime() # The getTime() method returns the number of milliseconds between midnight of January 1, 1970 and the specified date

# Emulate the fetching of the price list for this item by
# loading the JSON from file. Takes about 2ms to 3ms
price = require('./pricing.json')
#console.log price["@IsoCode"]
#console.log price

###
rb:2014-11-06: according to the following test, there are numerous methods to
convert a string to a number. The function parseInt is a lot slower than a
bitwise not, e.g. parseInt("1") is slower than parseInt("1",10), but both
are much slower than ~~"1".
http://jsperf.com/number-vs-parseint-vs-plus/47
###

###
x = (num for num in [1..10] when not (num % 2))
console.log x
###

# Filtering and sorting functions
testDayRange = (arr, stDtIso, endDtIso, dayAttribute) -> (
  arr[dayAttribute] >= stDtIso and arr[dayAttribute] <= endDtIso
)

# Test an array with begin and end dates and return all elements that
# in any way overlap the booking period.
testDateRange = (arr, stDtIso, endDtIso, stDtAttr, endDtAttr) -> (
  (arr[stDtAttr] <= stDtIso\
  and stDtIso <= arr[endDtAttr]\
  and arr[stDtAttr] <= endDtIso\
  and endDtIso <= arr[endDtAttr]\
  )\
  or
  (stDtIso <= arr[stDtAttr]\
  and arr[stDtAttr] <= endDtIso\
  and stDtIso <= arr[endDtAttr]\
  and arr[endDtAttr] <= endDtIso\
  )\
  or
  (arr[stDtAttr] <= stDtIso\
  and stDtIso <= arr[endDtAttr]\
  and endDtIso > arr[endDtAttr]\
  )\
  or
  (arr[stDtAttr] <= endDtIso\
  and endDtIso <= arr[endDtAttr]\
  and stDtIso < arr[stDtAttr]\
  )
)

sortDaysDesc = (a, b) ->
  if parseInt(a["@Days"]) > parseInt(b["@Days"])
    ( - 1 )
  else if parseInt(a["@Days"]) < parseInt(b["@Days"])
    ( 1 )
  else
    0

sortDaysAsc = (a, b) ->
  if parseInt(a["@Days"]) > parseInt(b["@Days"])
    ( 1 )
  else if parseInt(a["@Days"]) < parseInt(b["@Days"])
    ( - 1 )
  else
    0

buildDateRangeArray = (newDt, endDt) ->
  #without a start date this function makes no sense.
  #Explicit return and quick exit out of this function
  if !newDt
    return []
  dateRange = []
  while (newDt <= endDt)
    #range.push(new Date(newDate), newDate.getFullYear().toString() + '-' + (newDate.getMonth() + 1).toString() + '-' + newDate.getDate().toString())
    #dateRange.push(new Date(newDt), (newDt.toISOString()).substring(0, 10))
    dateRange.push((newDt.toISOString()).substring(0, 10))
    newDt.setDate(newDt.getDate() + 1)
  dateRange

swapDateString = (stDtIso, endDtIso) ->
  # If the enddate is empty, copy the value of the startdate into the enddate
  if !endDtIso
    endDtIso = stDtIso
  #If necessary swap the values of the start and end date strings
  if endDtIso < stDtIso
    tmpString = endDtIso
    endDtIso = stDtIso
    stDtIso = tmpString
  [stDtIso, endDtIso] # this is an example or returning multiple return values

addDefaultToObjectArray = (arr, kvobj) ->
  # Assign default values to objects in an array based on a passed object
  arr = (
    for a in arr
      for k, v of kvobj
        a[k] ?= v
      a
    )
  arr

addTotalToPrice = (arr, NrPax) ->
  arr["Nr"] ?= 0
  arr["Nr"] = 0 + arr["Nr"] + NrPax
  arr["Seq"] ?= []
  arr["Seq"].push(normPaxSeqArray)
  arr["Total"] ?= 0
  arr["Total"] = 0 + arr["Total"] + ( res["Nr"] * res["@Price"] )
  arr

# Parameters necessary for the actual pricing calculation process
currentDateString = "2014-10-03"
stDtIso = "2014-12-20"
endDtIso = "2014-12-30"
overnightFlag = true
paxList = [
  {seq: 1, age: 30}
  {seq: 2, age: 40}
  {seq: 3, age: 7}
  {seq: 4, age: 6}
  ]
normPaxNr = 2
lang = "de"
currency = "CHF"

# START: Basic error handling based on the passed parameters
# If a start date is not supplied, then a pricing is not possible
if not stDtIso? then return []

# If a pax list is not supplied, then a pricing is not possible
# TODO: it might make sense to pass pax numbers, e.g. 2 ADT, 3 CHD and then
#   build the pax list dynamically
if not paxList? then return []

# An empty normal occupancy is an error
if not normPaxNr? then return []

# An normal occupancy of <1 makes no sense
if normPaxNr < 1 then return []

# END: Basic error handling based on the passed parameters

# Assign each pax a default age of 30 if an age is not provided
# This makes sorting and searching for pax easier
paxList = addDefaultToObjectArray(paxList, {'age' : '30'})
# Sort by age descending
paxList.sort((a, b) -> a["age"] < b["age"])
###
Split up the pax list into a list for normal occupancy
  and a list for the additional pax in the room.
  This makes working with the per day prices easier, as
  it does not matter if a pax is a child or nt for the
  normal occupancy. The pax always pays the full price.
###
normPaxList = paxList[...normPaxNr]
normPaxSeqArray = _.map(normPaxList, (x) -> (x.seq) )
addPaxList = paxList[normPaxNr..]
addPaxSeqArray = _.map(addPaxList, (x) -> (x.seq) )

#Ensure that the overnight flag is either true or false (default true)
if overnightFlag? is not false then overnightFlag = true

# Ensure that if the current date is not passed that it is calculated
if (!currentDateString)
  currentDateString = new (Date().toISOString()).substring(0, 10)
#stDt = moment(stDtIso)
#console.log stDt

# The startdate must always be smaller than the enddate
[stDtIso, endDtIso] = swapDateString(stDtIso, endDtIso) #multiple return values

# The currentDateString cannot be larger than the startdate
if currentDateString > stDtIso
  currentDateString = new Date(stDtIso)

stDt = new Date(stDtIso)
endDt = new Date(endDtIso)

#If this is an overnight stay then the last day is not pricing relevant
if overnightFlag and stDtIso < endDtIso
  endDt.setDate(endDt.getDate() - 1)
  endDtIso = (endDt.toISOString()).substring(0, 10)

#Dynamically calculate the number of days between two dates
DAY = 1000 * 60 * 60 * 24
nrDays = Math.round((endDt.getTime() - stDt.getTime()) / DAY)

# Build a range of dates from the startdate to the enddate
dateRange = buildDateRangeArray(stDt, endDt)

# Extract portions of the pricing array into seperate arrays
perDayPrices = price["PerDayPrices"] or []
addPerDayPrices = price["AddPerDayPrices"] or []
oneTimes = price["OneTimes"] or []
specialOffers = price["SpecialOffers"] or []
earlyBookings = price["EarlyBookings"] or []

perDayPricesDefaultObj = {
  '@NotSpecialRelevant': '0'
  '@SpecialCommission': '0'
  '@AgeFrom': '0'
  '@AgeTo': '0'
  '@Type': 'P'
}

# perDayPricesRoom
perDayPricesRoom = (a for a in perDayPrices when testDayRange(a, stDtIso, endDtIso, "@Day") and a["@Type"] is "R")
perDayPricesRoom.sort((a, b) -> a["@Day"] > b["@Day"])
# Attributes NotSpecialRelevant, SpecialCommission need default values
perDayPricesRoom = addDefaultToObjectArray(perDayPricesRoom, perDayPricesDefaultObj )

# perDayPricesPerson
perDayPricesPerson = (a for a in perDayPrices when testDayRange(a, stDtIso, endDtIso, "@Day") and (a["@Type"] is "P" or not a["@Type"]? ))
perDayPricesPerson.sort((a, b) -> a["@Day"] > b["@Day"])
perDayPricesPerson = addDefaultToObjectArray(perDayPricesPerson, perDayPricesDefaultObj )

# addPerDayPricesRoom
addPerDayPricesRoom = (a for a in addPerDayPrices when testDayRange(a, stDtIso, endDtIso, "@Day") and a["@Type"] is "R")
addPerDayPricesRoom.sort((a, b) -> a["@Day"] > b["@Day"])
addPerDayPricesRoom = addDefaultToObjectArray(addPerDayPricesRoom, perDayPricesDefaultObj )

# addPerDayPricesPerson
addPerDayPricesPerson = (a for a in addPerDayPrices when testDayRange(a, stDtIso, endDtIso, "@Day") and (a["@Type"] is "P" or not a["@Type"]? ))
addPerDayPricesPerson.sort((a, b) -> a["@Day"] > b["@Day"])
addPerDayPricesPerson = addDefaultToObjectArray(addPerDayPricesPerson, perDayPricesDefaultObj )

oneTimesDefaultObj = {
  '@NotSpecialRelevant': '0'
  '@SpecialCommission': '0'
  '@AgeFrom': '0'
  '@AgeTo': '0'
  '@Baby': '0'
  '@Child': '0'
}

# oneTimesRoom
oneTimesRoom = (a for a in oneTimes when testDateRange(a, stDtIso, endDtIso, "@DateFrom","@DateTo") and a["@Type"] is "R")
oneTimesRoom.sort((a, b) -> a["@DateFrom"] > b["@DateFrom"])
oneTimesRoom = addDefaultToObjectArray(oneTimesRoom, oneTimesDefaultObj )

# oneTimesPerson
oneTimesPerson = (a for a in oneTimes when testDateRange(a, stDtIso, endDtIso, "@DateFrom","@DateTo") and (a["@Type"] is "P" or not a["@Type"]? ))
oneTimesPerson.sort((a, b) -> a["@DateFrom"] > b["@DateFrom"])
oneTimesPerson = addDefaultToObjectArray(oneTimesPerson, oneTimesDefaultObj )

# specialOffers
specialOffers = (a for a in specialOffers when testDateRange(a, stDtIso, endDtIso, "@DateFrom","@DateTo"))
specialOffers = (a for a in specialOffers when parseInt( a["@Days"]) <= nrDays)
specialOffers.sort(sortDaysDesc)
specialOffers = addDefaultToObjectArray(oneTimesPerson, oneTimesDefaultObj )

earlyBookingsDefaultObj = {
  '@Percent': '0'
  '@ForceDisplay': '0'
  '@ForAllDays': '0'
  '@SpecialCommission': '0'
}

# earlyBookings
earlyBookings = (a for a in earlyBookings when testDateRange(a, stDtIso, endDtIso, "@DateFrom","@DateTo"))
earlyBookings = (a for a in earlyBookings when parseInt( a["@Days"]) <= nrDays)
earlyBookings.sort(sortDaysDesc)
earlyBookings = addDefaultToObjectArray(earlyBookings, earlyBookingsDefaultObj )

# Preperation of arrays is now completed
# Now the actual pricinig calculation can start

perDayResult = []
addPerDayResult = []
oneTimesResult = []

for dayObj in dateRange
  #TODO: What happens if there is a missing element in the day list
  # First check if there is a room price for this day
  # Note: there can only be one perDayPrice per day, so here we can use "_.find"
  res = _.find(perDayPricesRoom, (x) -> (x["@Day"] is dayObj))
  if (res? )
    res = addTotalToPrice(res, "1")
    perDayResult.push(res)
  else
    # Only if there isn't a room price check if there is a per person price for this day
    res = _.find(perDayPricesPerson, (x) -> (x["@Day"] is dayObj))
    if (res? )
      res = addTotalToPrice(res, "#{normPaxNr}")
      perDayResult.push(res)

  resArray = _.filter(addPerDayPricesRoom, (x) -> (x["@Day"] is dayObj))
  if resArray.length > 0 then (
    _.map(resArray, (res) -> (
      res = addTotalToPrice(res, "1")
      addPerDayResult.push(res)
    ))
  )

  resArray = _.filter(addPerDayPricesPerson, (x) -> (x["@Day"] is dayObj))
  if resArray.length > 0 then (
    _.map(resArray, (res) -> (
      res = addTotalToPrice(res, "#{normPaxNr}")
      addPerDayResult.push(res)
    ))
  )

if perDayResult.length > 0 and perDayResult.length < dateRange.length then return []

#for oneTime in oneTimesPerson
#  console.log "oneTime: #{JSON.stringify(oneTime)}"

# Timing end
endDt = new Date().getTime() # The getTime() method returns the number of milliseconds between midnight of January 1, 1970 and the specified date

console.log "Timer duration: #{endDt - startDt} ms"
console.log "Calculated stay duration: #{nrDays} days"
console.log ">>> Pax list: #{JSON.stringify(paxList)}"
console.log ">>> Norm Pax list: #{JSON.stringify(normPaxList)} SeqArray: #{JSON.stringify(normPaxSeqArray)}"
console.log ">>> Add Pax list: #{JSON.stringify(addPaxList)} SeqArray: #{JSON.stringify(addPaxSeqArray)}"
console.log ""
console.log ">>> Date range: #{JSON.stringify(dateRange)}"
console.log ""
console.log ">>> perDayPricesRoom: #{JSON.stringify(perDayPricesRoom)}"
console.log ""
console.log ">>> perDayPricesPerson: #{JSON.stringify(perDayPricesPerson)}"
console.log ""
console.log ">>> addPerDayPricesRoom: #{JSON.stringify(addPerDayPricesRoom)}"
console.log ""
console.log ">>> addPerDayPricesPerson: #{JSON.stringify(addPerDayPricesPerson)}"
console.log ""
console.log ">>> oneTimesRoom: #{JSON.stringify(oneTimesRoom)}"
console.log ""
console.log ">>> oneTimesPerson: #{JSON.stringify(oneTimesPerson)}"
console.log ""
console.log ">>> specialOffers: #{JSON.stringify(specialOffers)}"
console.log ""
console.log ">>> earlyBookings: #{JSON.stringify(earlyBookings)}"
console.log ""
console.log ">>> perDayResult: #{JSON.stringify(perDayResult)}"
