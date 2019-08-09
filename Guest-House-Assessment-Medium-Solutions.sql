/* https://sqlzoo.net/wiki/Guest_House_Assessment_Medium */

--6.
/*Ruth Cadbury. Show the total amount payable by guest Ruth Cadbury for her room bookings. 
You should JOIN to the rate table using room_type_requested and occupants.
+--------------------+
| SUM(nights*amount) |
+--------------------+
|             552.00 |
+--------------------+
*/
SELECT SUM(nights*amount)
FROM booking JOIN rate  ON (room_type_requested=room_type AND occupants=occupancy)
             JOIN guest ON (guest.id=booking.guest_id)
WHERE first_name = 'Ruth' AND last_name = 'Cadbury'

--7.
/*Including Extras. Calculate the total bill for booking 5346 including extras.
+-------------+
| SUM(amount) |
+-------------+
|      118.56 |
+-------------+
*/
-- probably incorrect
SELECT SUM(rate.amount + extra.amount)
FROM booking JOIN extra ON (booking.booking_id=extra.booking_id)
             JOIN rate ON  (room_type_requested=room_type) AND (occupancy=occupants)
WHERE booking.booking_id = 5346

--8.
/*Edinburgh Residents. For every guest who has the word “Edinburgh” in their address show the total number of nights booked. 
Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. 
Order by last name then first name.
+-----------+------------+---------------------------+--------+
| last_name | first_name | address                   | nights |
+-----------+------------+---------------------------+--------+
| Brock     | Deidre     | Edinburgh North and Leith |      0 |
| Cherry    | Joanna     | Edinburgh South West      |      0 |
| Murray    | Ian        | Edinburgh South           |     13 |
| Sheppard  | Tommy      | Edinburgh East            |      0 |
| Thomson   | Michelle   | Edinburgh West            |      3 |
+-----------+------------+---------------------------+--------+
*/
SELECT last_name, first_name, address, 
CASE WHEN SUM(nights) IS NULL
     THEN 0
     ELSE SUM(nights)
     END AS nights
FROM guest LEFT JOIN booking ON (id=guest_id)
WHERE address LIKE '%Edinburgh%'
GROUP BY last_name, first_name, address
ORDER BY last_name, first_name


--9.
/*How busy are we? For each day of the week beginning 2016-11-25 show the number of bookings starting that day. 
Be sure to show all the days of the week in the correct order.
+------------+----------+
| i          | arrivals |
+------------+----------+
| 2016-11-25 |        7 |
| 2016-11-26 |        8 |
| 2016-11-27 |       12 |
| 2016-11-28 |        7 |
| 2016-11-29 |       13 |
| 2016-11-30 |        6 |
| 2016-12-01 |        7 |
+------------+----------+
*/
SELECT booking_date AS i, COUNT(guest_id) AS arrivals
FROM booking
WHERE booking_date BETWEEN '2016-11-25' AND '2016-12-01'
GROUP BY i

--10.
/*How many guests? Show the number of guests in the hotel on the night of 2016-11-21. 
Include all occupants who checked in that day but not those who checked out.
+----------------+
| SUM(occupants) |
+----------------+
|             39 |
+----------------+
*/
SELECT SUM(occupants) FROM booking
WHERE booking_date <= '2016-11-21' AND DATE_ADD(booking_date, INTERVAL nights DAY) > '2016-11-21'
