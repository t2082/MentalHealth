const GetSongs = require("../../application/usecases/GetSongs");

class SongController {
    static async all(req, res){
        try{
            const getSongs = new GetSongs();
            const songs = await getSongs.execute();
            res.json(songs) ;
        } catch(error){
            res.status(500).json({error: error.message});
        }
    }
}

module.exports = SongController;