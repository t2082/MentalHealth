const Songs = require("../../domain/entities/Songs");
const { getAllSongs } = require("../../infrastructure/database/queries/songQueries");
const UsercaseInterface = require("../interfaces/UsecaseInterface");

class GetSongs extends UsercaseInterface {
    async execute() {
        const songRows = await getAllSongs();
        if (songRows == null) { console.log('Có lỗi xảy ra GetSongs.js'); return }
        console.log('GetSongs.js : Đã lấy tất cả nhạc !');
        return songRows.map(song => new Songs({
            id: song.id,
            title: song.title,
            author: song.author,
            songlink: song.songlink
        }));
    }
}

module.exports = GetSongs;