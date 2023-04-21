# roleplay_kit

A new Flutter project for providing custom text game experience

*Roleplay Kit is currently designed for turn-by-turn roleplaying.*

### Pipeline
CURRENTLY ON : Saving and a 'regenerate' button.

UP NEXT : Lang Selection & Character generation (AI/Procedural), and then game theme selection

## Features (TBD)
- AI-backed (thru API) content generation & presentation
- Game Mechanincs running on top of ordinary LLMs
- Game can be influenced by non-text (but quantifiable) attr, through custom widgets
- Groupchat-esque multiplayer support

Universal API mapping support is coming, but since OpenAI APIs are *reasonable* this project currently only supports chatGPT-backed content generation.

## Running
Add a `.env` file to project root. You will need an OpenAI account (with payment methods set up).
```
// .env
OPEN_AI_API_KEY=<REPLACE WITH YOUR API KEY>
```
Then, run `flutter pub run build_runner build` (one time only)

## Costs
Based on [April 2023 pricing](https://openai.com/pricing), expect 0.2 cents per 300 words of user input (or 750 words total, or ~20 turns?)

한글의 경우 1자당 1토큰, 즉 원고지 1장(200자) 분량 입력에 약 2.5원으로 계산하시면 됩니다. 공백은 보통 제외됩니다.

### NOTE for non-alphabetic language
* Depending on the Tokenizer, broken letters may appear. This WILL cause problems.
* OpenAI's tokenizer is **VERY INEFFICIENT** at tokenizing Korean, resulting in expensive API costs(~3x from English) and slow generation times *especially with GPT4*

## Misc
It may take a while for OpenAI API access to be granted, even after adding a payment method.