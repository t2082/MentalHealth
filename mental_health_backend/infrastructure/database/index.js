const { query } = require('express');
const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',  // Địa chỉ máy chủ MySQL (có thể là remote host)
    user: 'root',       // Tên người dùng MySQL
    password: '',  // Mật khẩu MySQL
    database: 'mental_health_app'   // Tên cơ sở dữ liệu
});

connection.connect((err) => {
    if (err) {
        console.error('Có lỗi xảy ra: ', err.stack);
        return;
    }
    console.log('Kết nối thành công MySQL với cổng: ' + connection.threadId);
});

// connection.end();


module.exports = connection;