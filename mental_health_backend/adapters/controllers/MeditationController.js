const GetAdviceByMood = require("../../application/usecases/GetAdviceByMood");
const GetDailyQuotes = require("../../application/usecases/GetDailyQuotes");
const GeminiApi = require("../../infrastructure/gemini/GeminiServices");

class MeditationController {
    static async dailyQuote(req, res) {
        try {
            const getDailyQuotes = new GetDailyQuotes(new GeminiApi());
            const quotes = await getDailyQuotes.execute();
            res.json(quotes)
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    }

    static async myMood(req, res) {
        try {
            const {mood} = req.params;
            const getAdviceByMood = new GetAdviceByMood(new GeminiApi());
            const quotes = await getAdviceByMood.execute(mood);
            res.json(quotes)
        } catch (error) {
            res.status(500).json({ error: error.message })
        }
    }
}

module.exports = MeditationController;