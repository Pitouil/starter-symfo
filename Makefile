up:
	@docker compose down
	@docker compose build --no-cache --build-arg USER_ID=$$(id -u) --build-arg GROUP_ID=$$(id -g) && docker compose up -d

php:
	@docker exec -it ai_test_php bash

node:
	@docker exec -it ai_test_node bash