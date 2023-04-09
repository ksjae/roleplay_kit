# roleplay_kit

A new Flutter project for providing custom text game experience
~~and a Copilot playground~~

## Features
- AI-backed (thru API) content generation & presentation
- Game Mechanincs running on top of ordinary LLMs
- Game can be influenced by non-text (but quantifiable) attr, through custom widgets

Universal API mapping support is coming, but since OpenAI APIs are *reasonable* this project currently only supports chatGPT-backed content generation.

## Running
Add a `.env` file to project root.
```
// .env
OPEN_AI_API_KEY=<REPLACE WITH YOUR API KEY>
```
Then, run `flutter pub run build_runner build` (one time only)

### NOTE for non-alphabetic language
* Depending on the Tokenizer, broken letters may appear. This WILL cause problems.
* OpenAI's tokenizer is **VERY INEFFICIENT** at tokenizing Korean, resulting in expensive API costs(~3x from English).