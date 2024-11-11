-- Inserción de datos

-- Inserción de Clientes
INSERT INTO Clientes (nombre, direccion, telefono, email, ci) VALUES
('Juan Pérez', 'Calle A, 123', '12345678', 'juan@example.com', '12345678'),
('Ana López', 'Calle B, 456', '87654321', 'ana@example.com', '87654321'),
('Luis García', 'Calle C, 789', '11223344', 'luis@example.com', '11223344'),
('María Rodríguez', 'Calle D, 159', '22334455', 'maria@example.com', '22334455'),
('José Martínez', 'Calle E, 753', '33445566', 'jose@example.com', '33445566'),
('Carla Torres', 'Calle F, 258', '44556677', 'carla@example.com', '44556677'),
('Pedro Sánchez', 'Calle G, 369', '55667788', 'pedro@example.com', '55667788'),
('Laura Ramírez', 'Calle H, 147', '66778899', 'laura@example.com', '66778899'),
('Javier Cruz', 'Calle I, 258', '77889900', 'javier@example.com', '77889900'),
('Sofía Morales', 'Calle J, 369', '88990011', 'sofia@example.com', '88990011'),
('Diego Fernández', 'Calle K, 123', '99991122', 'diego@example.com', '99991122'),
('Natalia Ortega', 'Calle L, 456', '00012233', 'natalia@example.com', '00012233'),
('Fernando Silva', 'Calle M, 789', '11123344', 'fernando@example.com', '11123344'),
('Isabel Vargas', 'Calle N, 159', '22234455', 'isabel@example.com', '22234455'),
('Roberto Jiménez', 'Calle O, 753', '33345566', 'roberto@example.com', '33345566'),
('Patricia Díaz', 'Calle P, 258', '44456677', 'patricia@example.com', '44456677'),
('Carlos Herrera', 'Calle Q, 369', '55567788', 'carlos@example.com', '55567788'),
('Andrea Castro', 'Calle R, 147', '66678899', 'andrea@example.com', '66678899'),
('Manuel Ruiz', 'Calle S, 258', '77789900', 'manuel@example.com', '77789900'),
('Gonzalo Peña', 'Calle T, 369', '88890011', 'gonzalo@example.com', '88890011'),
('Marta Rojas', 'Calle U, 123', '99991122', 'marta@example.com', '99991122'),
('Pablo Díaz', 'Calle V, 456', '00012233', 'pablo@example.com', '00012233'),
('Elena Núñez', 'Calle W, 789', '11123344', 'elena@example.com', '11123344'),
('Victor Salas', 'Calle X, 159', '22234455', 'victor@example.com', '22234455'),
('Teresa Castillo', 'Calle Y, 753', '33345566', 'teresa@example.com', '33345566'),
('Ricardo Peña', 'Calle Z, 258', '44456677', 'ricardo@example.com', '44456677');

-- Inserción de Empresas
INSERT INTO Empresas (nombre, rubro, NIT, direccion, telefono, email) VALUES
('Empresa A', 'Rubro A', '123456', 'Dirección A', '12345678', 'empresaA@example.com'),
('Empresa B', 'Rubro B', '234567', 'Dirección B', '87654321', 'empresaB@example.com'),
('Empresa C', 'Rubro C', '345678', 'Dirección C', '11223344', 'empresaC@example.com'),
('Empresa D', 'Rubro D', '456789', 'Dirección D', '22334455', 'empresaD@example.com'),
('Empresa E', 'Rubro E', '567890', 'Dirección E', '33445566', 'empresaE@example.com');

-- Inserción de Productos
INSERT INTO Productos (nombre, descripcion, precio_unitario, stock, categoria, estado) VALUES
('Producto 1', 'Descripción del Producto 1', 10.00, 100, 'Categoría 1', 'activo'),
('Producto 2', 'Descripción del Producto 2', 15.00, 150, 'Categoría 1', 'activo'),
('Producto 3', 'Descripción del Producto 3', 20.00, 200, 'Categoría 2', 'activo'),
('Producto 4', 'Descripción del Producto 4', 25.00, 250, 'Categoría 2', 'activo'),
('Producto 5', 'Descripción del Producto 5', 30.00, 300, 'Categoría 3', 'activo'),
('Producto 6', 'Descripción del Producto 6', 12.00, 120, 'Categoría 1', 'activo'),
('Producto 7', 'Descripción del Producto 7', 18.00, 180, 'Categoría 3', 'activo'),
('Producto 8', 'Descripción del Producto 8', 22.00, 220, 'Categoría 2', 'activo'),
('Producto 9', 'Descripción del Producto 9', 27.00, 270, 'Categoría 3', 'activo'),
('Producto 10', 'Descripción del Producto 10', 32.00, 320, 'Categoría 1', 'activo'),
('Producto 11', 'Descripción del Producto 11', 14.00, 140, 'Categoría 2', 'activo'),
('Producto 12', 'Descripción del Producto 12', 19.00, 190, 'Categoría 3', 'activo'),
('Producto 13', 'Descripción del Producto 13', 24.00, 240, 'Categoría 1', 'activo'),
('Producto 14', 'Descripción del Producto 14', 29.00, 290, 'Categoría 2', 'activo'),
('Producto 15', 'Descripción del Producto 15', 34.00, 340, 'Categoría 3', 'activo'),
('Producto 16', 'Descripción del Producto 16', 16.00, 160, 'Categoría 1', 'activo'),
('Producto 17', 'Descripción del Producto 17', 21.00, 210, 'Categoría 2', 'activo'),
('Producto 18', 'Descripción del Producto 18', 26.00, 260, 'Categoría 3', 'activo'),
('Producto 19', 'Descripción del Producto 19', 31.00, 310, 'Categoría 1', 'activo'),
('Producto 20', 'Descripción del Producto 20', 36.00, 360, 'Categoría 2', 'activo');

-- Inserción de Facturas
INSERT INTO Facturas (numero_factura, id_cliente, id_empresa, fecha, total, estado) VALUES
('FAC-001', 1, 1, '2024-11-01', 100.00, 'completado'),
('FAC-002', 2, 2, '2024-11-02', 150.00, 'completado'),
('FAC-003', 3, 3, '2024-11-03', 200.00, 'pendiente'),
('FAC-004', 4, 4, '2024-11-04', 250.00, 'completado'),
('FAC-005', 5, 5, '2024-11-05', 300.00, 'anulado'),
('FAC-006', 6, 1, '2024-11-01', 120.00, 'completado'),
('FAC-007', 7, 2, '2024-11-02', 180.00, 'pendiente'),
('FAC-008', 8, 3, '2024-11-03', 240.00, 'completado'),
('FAC-009', 9, 4, '2024-11-04', 300.00, 'completado'),
('FAC-010', 10, 5, '2024-11-05', 360.00, 'pendiente');

-- Inserción de Detalles de Factura
INSERT INTO Detalle_Factura (id_factura, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 1, 10.00, 10.00),
(1, 2, 2, 15.00, 30.00),
(2, 3, 1, 20.00, 20.00),
(2, 4, 1, 25.00, 25.00),
(3, 5, 3, 30.00, 90.00),
(3, 6, 2, 12.00, 24.00),
(4, 7, 1, 18.00, 18.00),
(4, 8, 3, 22.00, 66.00),
(5, 9, 2, 27.00, 54.00),
(5, 10, 1, 32.00, 32.00),
(6, 11, 1, 14.00, 14.00),
(6, 12, 2, 19.00, 38.00),
(7, 13, 3, 24.00, 72.00),
(7, 14, 1, 29.00, 29.00),
(8, 15, 2, 34.00, 68.00),
(8, 16, 1, 16.00, 16.00),
(9, 17, 1, 21.00, 21.00),
(9, 18, 2, 26.00, 52.00),
(10, 19, 3, 31.00, 93.00),
(10, 20, 1, 36.00, 36.00);

INSERT INTO Ventas (id_factura, fecha, total) VALUES
(1, '2024-11-01', 100.00),
(2, '2024-11-02', 150.00),
(3, '2024-11-03', 200.00),
(4, '2024-11-04', 250.00),
(5, '2024-11-05', 300.00),
(6, '2024-11-01', 120.00),
(7, '2024-11-02', 180.00),
(8, '2024-11-03', 240.00),
(9, '2024-11-04', 300.00),
(10, '2024-11-05', 360.00);