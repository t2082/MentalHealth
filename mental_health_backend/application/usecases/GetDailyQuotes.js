const Meditation = require("../../domain/entities/Meditation");
const UsercaseInterface = require("../interfaces/UsecaseInterface");

class GetDailyQuotes extends UsercaseInterface {
    constructor(quoteRepository) {
        super();
        this.quoteRepository = quoteRepository;
    }

    async execute() {
        const quoteData = await this.quoteRepository.getDailyQuotes();
        return new Meditation({ text: quoteData });
    }
}

module.exports = GetDailyQuotes;