# U8

## Install

## Docs
- The initial concept meeting is transcribed [in the concept file](docs/concept.md).

## License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## EidolonAI Setup
0. Docker required (for example docker desktop)
1. Run the following command to build a docker image based on the contents of the folder:
  ```bash
  docker build -t godot-agent ./eidolon
  ```
2. Create and run docker container using your openai apikey
  ```bash
  docker run -p 8080:8080 -e OPENAI_API_KEY=<YOUR OPENAI API KEY> godot-agent
  ```
