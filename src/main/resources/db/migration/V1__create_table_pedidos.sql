CREATE TABLE pedidos (
  id bigserial NOT NULL,
  data_hora timestamp NOT NULL,
  status varchar(255) NOT NULL,
  PRIMARY KEY (id)
);