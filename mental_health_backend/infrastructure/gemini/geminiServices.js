const { GoogleGenerativeAI } = require("@google/generative-ai");
const QuoteRepository = require("../../application/interfaces/QuotesReponsitory");

const genAi = new GoogleGenerativeAI("AIzaSyCTCt1X22NKdRUt6KiNsvFmiLXm9fyLG-8");
const model = genAi.getGenerativeModel({ model: "gemini-1.5-flash" })

class GeminiApi extends QuoteRepository {
    async getDailyQuotes() {
        const prompt = `Viết cho tôi 3 lời khuyên tích cực chữa lành tương ứng với 3 buổi trong ngày: sáng, trưa, chiều. Phản hồi lại cho tôi bằng định dạng JSON tương ứng như sau:
        {
            "morningQuote": "lời khuyên vào buổi sáng",
            "noonQuote": "lời khuyên vào buổi trưa",
            "eveningQuote": "lời khuyên vào buổi tối",
        } chỉ trả về kiểu json mà không sử dụng từ khóa json`;
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();
        return text;
    }

    async getAdviceByMood({mood}) {
        const prompt = `Với tâm trạng hiện tại của người dùng, viết cho tôi một nhiệm vụ chữa lành tâm trí thích hợp hoặc một lời khuyên chữa lành. Phản hồi lại cho tôi bằng định dạng JSON tương ứng như sau:
        {
            "advice":"Nhiệm vụ chữa lành hoặc lời khuyên" 
        }
        Tâm trạng hiện giờ của tôi là: ${mood}, chỉ trả về kiểu json mà không sử dụng từ khóa json
        `;
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();
        return text;
    }
}

module.exports = GeminiApi;