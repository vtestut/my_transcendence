NAME = node

all: $(NAME)

$(NAME) : up

up:
	docker-compose up --build

fclean:
	@docker stop $(NAME)
	@docker rm $(NAME)
	@docker rmi -f $(NAME)
	@docker volume rm $(NAME)
	@docker network rm $(NAME) 2>/dev/null || true

.PHONY: fclean