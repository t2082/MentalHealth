const Meditation = require("../../domain/entities/Meditation");
const UsercaseInterface = require("../interfaces/UsecaseInterface");

class GetAdviceByMood extends UsercaseInterface {
    constructor(quoteRepository) {
        super();
        this.quoteRepository = quoteRepository;
    }

    async execute(mood) {
        const quoteData = await this.quoteRepository.getAdviceByMood(mood);
        return new Meditation({ text: quoteData });
    }
}

module.exports = GetAdviceByMood;