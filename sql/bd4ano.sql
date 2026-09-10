--  e-commerce --
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabelas
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);

CREATE TABLE enderecos (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    rua VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(10) NOT NULL,

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE CASCADE
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) DEFAULT 'PENDENTE',
    valor_total DECIMAL(10,2) DEFAULT 0,

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE,

    FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
);

CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    metodo VARCHAR(30) NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDENTE',
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento TIMESTAMP NULL,

    FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
);

-- Permissões

-- Administrador
CREATE USER 'admin'@'localhost'
IDENTIFIED BY 'senha_admin';

GRANT ALL PRIVILEGES
ON ecommerce.*
TO 'admin'@'localhost';

-- Funcionário
CREATE USER 'funcionario'@'localhost'
IDENTIFIED BY 'senha_funcionario';

GRANT SELECT, INSERT, UPDATE
ON ecommerce.produtos
TO 'funcionario'@'localhost';

GRANT SELECT, INSERT, UPDATE
ON ecommerce.categorias
TO 'funcionario'@'localhost';

GRANT SELECT
ON ecommerce.pedidos
TO 'funcionario'@'localhost';

GRANT SELECT
ON ecommerce.itens_pedido
TO 'funcionario'@'localhost';

GRANT SELECT
ON ecommerce.pagamentos
TO 'funcionario'@'localhost';

-- Cliente
CREATE USER 'cliente'@'localhost'
IDENTIFIED BY 'senha_cliente';

GRANT SELECT
ON ecommerce.produtos
TO 'cliente'@'localhost';

GRANT SELECT
ON ecommerce.categorias
TO 'cliente'@'localhost';

GRANT SELECT, INSERT, UPDATE
ON ecommerce.enderecos
TO 'cliente'@'localhost';

-- Mostrar permissões
SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'funcionario'@'localhost';
SHOW GRANTS FOR 'cliente'@'localhost';