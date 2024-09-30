const connection = require('..');

const getAllSongs = () => {
    return new Promise((resolve, reject) => {
        connection.query('SELECT * FROM songs', (err, results, fields) => {
            if (err) {
                console.error('Error executing query:', err);
                return reject(err); // Trả lỗi về Promise
            }
            resolve(results); // Trả kết quả về Promise
        });
    });
};

module.exports = { getAllSongs };
