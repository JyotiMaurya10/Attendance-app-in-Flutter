const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const cors = require("cors");
const nodemailer = require("nodemailer");
const app = express();
const port = 5080; // Define the port
//
//app.listen(3333, () => {
//  console.log('Server is running on port 3333');
//});
//app.use(cors());
//
//// Your routes and other middleware
//
//app.listen(3333, () => {
//  console.log('Server is running on port 3333');
//});

// Create a MySQL connection pool
const pool = mysql.createPool({
  host: 'localhost',
  port: 3333,
  user: 'root',
  password: 'mysql',
  database: 'attend',

});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());



//some things which are used in the for communication between different api's
let data;
let ddate;
app.post('/date', (req, res) => {
  ddate = req.body.date;

  function formatTime(inputTime) {
    // Split the time string into hours and minutes
    const [datePart, timePart] = inputTime.split('_');
    const [hours, minutes] = timePart.split(':');

    // Ensure the minutes part has two digits (padded with leading zero)
    const formattedMinutes = minutes.length === 1 ? `0${minutes}` : minutes;

    // Reconstruct the time string with the formatted minutes
    const formattedTime = `${hours}:${formattedMinutes}`;

    // Join the date and formatted time
    return `${datePart}_${formattedTime}`;
  }
  ddate = formatTime(ddate);
  console.log(ddate);
  res.status(200).json({ message: 'Date updated successfully' });
});



// to take the attendence first name and roll number will be send to the flutter ap
app.get('/takedata', (req, res) => {

  pool.getConnection((err, connection) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    console.log(ddate);
    const checkColumnSQL = "SHOW COLUMNS FROM records LIKE  '" + ddate + "'";
    connection.query(checkColumnSQL, (err, results) => {
      if (err) {
        console.error(err);
        connection.release();
        return;
      }

      if (results.length == 0) {
        // The column doesn't exist, so create it
        const sql = 'SELECT roll_no, name FROM records'; // Replace with your actual table name
        connection.query(sql, (err, results) => {
          connection.release(); // Release the connection back to the pool

          if (err) {
            console.error(err);

            return res.status(500).json({ error: 'Error fetching data' });
          }

          // Extract the rows from the query results

          data = results.map((row) => {
            return {
              roll_no: row.roll_no,
              name: row.name,
            };
          });


          res.status(200).json(data); // Send the data as JSON response
          console.log(data);
        });
      } else {
        const sql = "SELECT roll_no, name ,`" + ddate + "`  FROM records"; // Replace with your actual table name
        connection.query(sql, (err, results) => {
          connection.release(); // Release the connection back to the pool

          if (err) {
            console.error(err);

            return res.status(500).json({ error: 'Error fetching data' });
          }

          // Extract the rows from the query results


          const formattedResults = results.map(row => ({
            1: row.roll_no,
            2: row.name,
            3: row[`${ddate}`],
          }));

          console.log(formattedResults);
          res.status(200).json(formattedResults); // Send the data as JSON response


        });
      }

    });
  });

});





//putdata start's here

app.post('/putdata', (req, res) => {
  const inputData = req.body;
  console.log(" putdata function called input is arrived ")
  console.log(inputData);
  const col_name = ddate; // Replace with a meaningful value

  // Check if the column exists before attempting to add it
  const checkColumnSQL = "SHOW COLUMNS FROM records LIKE  '" + col_name + "'";

  pool.getConnection((err, connection) => {
    if (err) {
      console.error(err);
      return;
    }

    connection.query(checkColumnSQL, (err, results) => {
      if (err) {
        console.error(err);
        connection.release();
        return;
      }

      if (results.length === 0) {
        // The column doesn't exist, so create it
        const createColumnSQL = 'ALTER TABLE records ADD ?? VARCHAR(2)';
        connection.query(createColumnSQL, [col_name], (err) => {
          if (err) {
            console.error(err);
          }
        });
      }

      // Now update the data for each student
      for (let roll_no in inputData) {
        let booleanValue = inputData[roll_no] == '0' ? 'A' : 'P';
        console.log(booleanValue + " " + roll_no + " " + col_name);
        updateBooleanValue(roll_no, booleanValue, connection, col_name);
      }

      // Handle the response to the client
      res.status(200).json({ message: 'Data updated successfully' });
      connection.release();
    });
  });
});

function updateBooleanValue(roll_no, booleanValue, connection, col_name) {
  const sql = 'UPDATE records SET ?? = ? WHERE roll_no = ?';

  connection.query(sql, [col_name, booleanValue, roll_no], (err) => {
    if (err) {
      console.error(err);
    }
  });
}

// putdata ends here


// for mailing the list of roll-no

function sendEmail(task, emails) {
  const mailTransporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'adarsh.224386101@vcet.edu.in',
      pass: 'vcet1234',
    },
  });

  const details = {
    from: 'adarsh.224386101@vcet.edu.in',
    to: emails.join(', '), // Join the emails into a comma-separated string
    subject: 'For testing the Andriod App',
    text: `Task: ${task}\nSender: adarsh`,
  };

  mailTransporter.sendMail(details, (err) => {
    if (err) {
      console.log(err + '\nIt has an error');
    } else {
      console.log('The email has been sent successfully');
    }
  });
}

app.post('/mail', (req, res) => {
  const rollNumbers = req.body.roll_no.split(' '); // Split roll_no string into an array
  const task = req.body.task; // Get the task

  pool.getConnection((err, connection) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    // if (err) {
    //      console.error('Error getting database connection:', err);
    //      return res.status(500).json({ error: 'Internal Server Error' });
    //    }
    // Construct a SQL query to select emails for the provided roll numbers
    const sql = `SELECT email FROM details WHERE roll_no IN (${rollNumbers.map(num => `'${num}'`).join(', ')})`;

    connection.query(sql, (err, results) => {
      connection.release();

      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Error fetching data' });
      }

      // Extract the email addresses from the query results
      const emails = results.map(result => result.email);

      // Print the emails in the console
      console.log('Emails:', emails);
      sendEmail(task, emails);

      // You can use the 'emails' array for further processing as needed.
      // If you want to send them as a response, you can modify the response accordingly.
      res.status(200); // Send the data as a JSON response
    });
  });
});










// to take the attendence first name and roll number will be send to the flutter ap
app.get('/details', (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    const sql = 'SELECT * FROM records'; // Replace with your actual table name
    connection.query(sql, (err, results) => {
      connection.release(); // Release the connection back to the pool

      if (err) {

        console.error(err);

        return res.status(500).json({ error: 'Error fetching data' });
      }

      // Extract the rows from the query results



      console.log(results);

      res.status(200).json(results); // Send the data as JSON response
    });
    console.log("function called details");
  });
});

















//to listen the port

app.listen(port, () => {
  console.log(`Server is running http://localhost:${port}`);
});





// for the  login page
// app.get('/', (req, res) => {
//   res.status(200).sendFile(__dirname + '/templates/index-form.html');
// });


// app.post('/', (req, res) => {
//   console.log(req.body);
//   var password = req.body.password;
//   var email = req.body.email;

//   pool.getConnection((err, connection) => {
//     if (err) {
//       console.log(err);
//       return res.status(500).send('Internal Server Error');
//     }

//     var sql = `INSERT INTO users (email, password) VALUES (?, ?)`;
//     connection.query(sql, [email, password], (err, result) => {

//       connection.release(); // Release the connection back to the pool

//       if (err) {
//         console.log(err);
//         return res.status(500).send('Error inserting data');
//       }

//       console.log('Data inserted successfully');
//       res.status(200).sendFile(__dirname + '/templates/index-form.html');
//     });
//   });
// });
