set DateStyle to 'ISO, DMY';
-- email
create domain Demail varchar(150)
check (value similar to '[0-z]%@[a-z]%.[a-z]%');

-- nombre de usuario
create domain Dnusuario varchar(150)
check (value similar to '[0-z]%');

-- uniform resources locator
create domain Durl varchar(200)
check (value similar to 'http://[a-z]%.[a-z]%/[a-z]%');

-- telefono
create domain Dtel varchar(15)
check (value similar to '+[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

-- posición geográfica
create domain Dpgeog varchar(23)
check (value similar to 
'-?[0-9]{1,3}.?[0-9]+, -?[0-9]{1,3}.?[0-9]+');

create table lugar (
id_lugar serial primary key,
coordenadas Dpgeog not null,
ciudad varchar(30) not null
);

create table imagen (
id_imagen serial primary key,
url Durl not null,
fecha_hora timestamp not null,
descripcion varchar(300)
);

create table video (
id_video serial primary key,
url Durl not null,
fecha_hora timestamp not null,
descripcion varchar(300)
);

create table audio (
id_audio serial primary key,
url varchar(150) not null,
fecha_hora timestamp not null,
descripcion varchar(300)
);

create table etiqueta (
id_etiqueta serial primary key,
texto varchar(20) unique not null
);

create table equipo (
id_equipo serial primary key,
nombre varchar(40) not null,
total_noticias int not null default 0,
fecha_creacion date not null
);

create table logro (
id_logro serial primary key,
nombre varchar(40) not null,
descripcion varchar(200),
requisitos varchar(200) not null,
puntos int default 0
);

create table usuario (
nombre_usuario Dnusuario primary key,
Estado_activo boolean not null,
nombre varchar(18) not null,
apellido1 varchar(18) not null,
apellido2 varchar(18) not null,
e_mail Demail not null,
contrasenna varchar(100) not null,
fecha_nacimiento timestamp not null,
id_lugar int not null,
id_imagen int not null,
constraint fkidlugar foreign key(id_lugar) references lugar,
constraint fkidimagen foreign key(id_imagen) references imagen
);

create table administrador (
nombre_usuario Dnusuario primary key,
fecha_nombramiento timestamp not null,
constraint fknusuario foreign key(nombre_usuario) references usuario
);

create table publicador (
nombre_usuario Dnusuario primary key,
puntos int not null default 0,
fecha_registro timestamp not null,
constraint fknusuario foreign key(nombre_usuario) references usuario
);

create table evento (
id_evento serial primary key,
nombre varchar(40) not null,
descripcion varchar(200) not null,
fecha_hora timestamp not null,
nombre_usuario Dnusuario not null,
id_lugar int not null,
constraint fknusuario foreign key(nombre_usuario) references usuario,
constraint fklugar foreign key(id_lugar) references lugar
);

create table post (
id_post serial primary key,
fecha_hora timestamp not null,
anonimo boolean default false,
contenido varchar(300) not null,
nombre_usuario Dnusuario not null,
estado_habilitado boolean default true,
id_lugar int not null,
id_equipo int not null,
constraint fkpublicador foreign key (nombre_usuario) references publicador,
constraint fkidlugar foreign key (id_lugar) references lugar,
constraint fkidequipo foreign key (id_equipo) references equipo
);

create table comentario (
id_comentario serial primary key,
fecha_hora timestamp not null,
contenido varchar(1000) not null,
id_post int not null,
nombre_usuario Dnusuario not null,
constraint fkidpost foreign key(id_post) references post,
constraint fknusuario foreign key(nombre_usuario) references usuario
);

create table mensaje (
id_mensaje serial primary key,
fecha_hora timestamp not null,
asunto varchar(40) not null,
contenido varchar(1000) not null,
nombre_usuario Dnusuario not null,
constraint fknusuario foreign key(nombre_usuario) references usuario
);
create table telefono (
nombre_usuario Dnusuario primary key,
telefono varchar(20) not null,
constraint fknusuario foreign key(nombre_usuario) references usuario
);

create table enviaMensaje (
nombre_usuario Dnusuario not null,
id_mensaje int,
constraint fknusuario foreign key (nombre_usuario) references usuario,
constraint fkidlogro foreign key (id_mensaje) references mensaje,
constraint pkEnviaMensaje primary key (nombre_usuario, id_mensaje)
);

create table obtieneLogro (
nombre_publicador varchar(20),
id_logro int,
constraint fkpublicador foreign key (nombre_publicador) references publicador,
constraint fkidlogro foreign key (id_logro) references logro,
constraint pkObtieneLogro primary key (nombre_publicador, id_logro)
);

create table sigue (
seguidor varchar(20),
seguido varchar(20),
constraint fkseguidor foreign key (seguidor) references publicador,
constraint fkseguido foreign key (seguido) references publicador,
constraint pksigue primary key (seguidor, seguido)
);

create table regula (
nombre_administrador varchar(20),
id_post int,
constraint fkadministrador foreign key (nombre_administrador) references administrador,
constraint fkidpost foreign key (id_post) references post,
constraint pkregula primary key (nombre_administrador, id_post)
);

create table califica (
nombre_publicador varchar(20),
id_post int,
puntos smallint not null,
constraint chkpuntos check (puntos between 0 and 100),
constraint fkpublicador foreign key (nombre_publicador) references publicador,
constraint fkidpost foreign key (id_post) references post,
constraint pkcalifica primary key (nombre_publicador, id_post)
);

create table perteneceEquipo (
nombre_publicador varchar(20),
id_equipo int,
constraint fknusuario foreign key (nombre_publicador) references publicador,
constraint fkidequipo foreign key (id_equipo) references equipo,
constraint pkPerteneceEquipo primary key (nombre_publicador, id_equipo)
);

create table relacionaEvento (
id_post int,
id_evento int,
constraint fkidpost foreign key (id_post) references post,
constraint fkideventoRelacionaEvento foreign key (id_evento) references evento,
constraint pkidevento primary key (id_post,id_evento)
);

create table relacionaAudio (
id_post int,
id_audio int,
constraint fkidpostrelacionaAudio foreign key (id_post) references post,
constraint fkidaudiorelacionaAudio foreign key (id_audio) references audio,
constraint pkrelacionaAudio primary key (id_post,id_audio)
);

create table relacionaVideo (
id_post int,
id_video int,
constraint fkidpostrelacionaVideo foreign key (id_post) references post,
constraint fkidvideorelacionaVideo foreign key (id_video) references video,
constraint pkrelacionaVideo primary key (id_post,id_video)
);

create table relacionaEtiqueta (
id_post int,
id_etiqueta int,
constraint fkidpostrelacionaEtiqueta foreign key (id_post) references post,
constraint fkidetiquetarelacionaEtiqueta foreign key (id_etiqueta) references etiqueta,
constraint pkrelacionaEtiqueta primary key (id_post,id_etiqueta)
);

create table relacionaImagen (
id_post int,
id_imagen int,
constraint fkidpostrelacionaImagen foreign key (id_post) references post,
constraint fkidimagenrelacionaImagen foreign key (id_imagen) references imagen,
constraint pkrelacionaImagen primary key (id_post,id_imagen)
);


--Algunas inserciones de prueba:

insert into lugar (coordenadas, ciudad)
values
('12, 15', 'Ciudad Quesada'),
('15, 17', 'Santa Clara'),
('-20.2, 182.34', 'Colonia Puntarenas'),
('-34.3, 2.54', 'Los Angeles'),
('97, 34', 'Orotina'),
('-36, 123', 'Tortuguero'),
('98, -234.22', 'Matína'),
('87.23, 13', 'Curridabat'),
('214, 76', 'Grecia'),
('87, 67', 'Zarcero'),
('12, 98', 'Agua caliente'),
('11.65, 54', 'Paquera'),
('-86, 75', 'Desamparados'),
('54, 12', 'Upala'),
('76, -45', 'Bijagua'),
('-20.6, 34.5', 'Sardinal'),
('120, -18', 'Cañas'),
('-10.2, 18', 'El Tanque'),
('63, 45', 'Liberia'),
('87, 189', 'San José'),
('35.3, -36', 'Los Yoses'),
('245, -123.2', 'Jacó'),
('0.0, 0.0', 'Default');


-- Imagenes
-- set datestyle to PostgreSQL,European; -- Esta línea indica que se use el estilo de fecha “europeo” por si da problemas cuando insertan fechas que llevan el día primero

insert into imagen (url,fecha_hora,descripcion)
values
('http://www.forodefotos.com/attachments/fotos-de-paisajes-y-naturaleza/11329d1273099502-fotos-de-
paisajes-fotos_paisajes.jpg','07-11-2011','Paisaje'),
('http://www.imagenes11.com/images/imagenes-paisajes-postal-p.jpg','07-11-2011','Paisaje'),
('http://fotohuellas.com/wp-content/uploads/2011/07/paisajes-del-mundo.jpg','07-11-2011 17:15','Paisaje'),
('http://th01.deviantart.net/fs70/PRE/i/2011/034/f/2/ciudad_by_collaimasumac-d38qym8.jpg', '24-11-2011', 'cuidad'),
('http://th01.deviantart.net/fs70/PRE/i/2011/034/f/2/ciudad_by_collaimasumac-d38qym8.jpg', '23-11-2011', 'hotel'),
('http://fc00.deviantart.net/fs70/f/2010/350/b/1/accidente_en_rbla_ghandi_by_000frank000-d3513la.jpg', '23-11-2011','ciudad'),
('http://fc08.deviantart.net/fs37/f/2008/255/4/7/Ciudad_by_RafieP_P.jpg', '23-11-2011', 'ciudad'),
('http://fc00.deviantart.net/fs70/f/2010/350/b/1/accidente_en_rbla_ghandi_by_000frank000-d3513la.jpg', '23-11-2011', 'accidente'),
('http://www.dogguie.com/wp-content/uploads/2009/09/accidente-horrible-moto-01.jpg', '23-11-2011', 'accidente'),
('http://www.definicionabc.com/wp-content/uploads/accidente-moto2.jpg', '23-11-2011', 'accidente'),
('http://www.tuabogadodefensor.com/images/accidente.jpg', '23-11-2011', 'accidente'),
('http://www.atodoautos.com/wp-content/uploads/2009/11/Dinamarca_accidente3.JPG', '23-11-2011', 'accidente'),
('http://noticias.telemedellin.tv/wp-content/uploads/2011/03/accidenteA.jpg', '23-11-2011', 'accidente');

-- usuarios
insert into usuario (nombre_usuario,estado_activo,nombre,apellido1,apellido2,e_mail,contrasenna,fecha_nacimiento,id_lugar,id_imagen)
values
('DilmerG','T','Dílmer','González','Hernández','d.j.g.h@hotmail.com','12345','25-09-1991','1','1'),
('Lav91','T','Alonso','Vega','Brenes','lav91@gmail.com','67890','02-03-1991','2','2'),
('Rumba','T','Enmanuelle','Oviedo','Ramírez','eoviedo@hotmail.com','11121','05-05-1992','2','3'),
('Alvar98','T','Alvaro','Rodriguez','Hernández','alvar@hotmail.com','12421','21-04-1989','22','3'),
('natY2','T','Natalia','Rojas','Flores','naTy@gmail.com','1234rt21','21-04-1999','14','4'),
('Syrip98','T','Syrfid','Rodriguez','Ruiz','ruiz@yahoo.com','12421','21-04-1989','12','12'),
('salDr','T','Sandra','Rodriguez','Sánches','sanches@gmail.com','145g521','21-04-1998','15','11'),
('desfr23','T','Rogelio','Rodriguez','Rosales','rosales@itcr.com','12sffd','21-04-1992','18','4'),
('coipt2','T','Pedro','Rodriguez','Alpizar','alpizar@gmail.com','12fg61','21-04-1991','13','5'),
('foco','T','Omar','Matamoros','Navarro','navarro@gmail.com','coco34','21-04-1990','15','6'),
('raizTrian','T','Alberto','Ordoñes','Hernández','cocomp@yahoo.com','nutmi21','21-04-1993','17','7'),
('novo','T','Ramón','Rodriguez','Martines','rrh@yahoo.com','12df432','21-04-1995','18','8'),
('mari21','T','Maritza','Arguello','Fonseca','mari21@itcr.com','navidad25','21-04-1994','13','9'),
('lolawer','T','Andrea','Robles','Hernández','lola@gmail.com','vacaciones!!XD','21-04-1995','14','1');


-- Publicadores
insert into publicador (nombre_usuario, fecha_registro) values
('DilmerG','15-11-2011'),
('Lav91','15-11-2011'),
('Rumba','15-11-2011'),
('Alvar98','15-11-2011'),
('natY2','15-11-2011'),
('Syrip98','16-11-2011'),
('salDr','16-11-2011'),
('desfr23','16-11-2011'),
('coipt2','16-11-2011'),
('foco','17-11-2011'),
('raizTrian','17-11-2011'),
('novo','17-11-2011'),
('mari21','17-11-2011'),
('lolawer','18-11-2011');

-- Administradores
insert into administrador values
('DilmerG','15-11-2011'),
('Lav91','15-11-2011'),
('Rumba','15-11-2011');

-- Sigue
insert into sigue values
('DilmerG','Rumba'),
('Lav91','Rumba'),
('Alvar98','DilmerG'),
('Alvar98','Lav91'),
('Lav91','natY2'),
('natY2','DilmerG'),
('coipt2','DilmerG'),
('desfr23','Rumba'),
('desfr23','Lav91'),
('salDr','natY2'),
('foco','raizTrian'),
('novo','mari21');

-- Equipos
insert into equipo (nombre, fecha_creacion) values
('Sin equipo', '1-11-2011'),
('AT&T','15-11-2011'),
('Rosa','15-11-2011'),
('Wachimanes','17-11-2011'),
('Sahuesos','17-11-2011'),
('Lookers','22-11-2011');

-- Post
insert into post (fecha_hora, contenido, nombre_usuario, id_lugar, id_equipo) values
('15-11-2011','Hubo un accidente en Ciudad Quesada', 'DilmerG',1,5),
('15-11-2011','Afortunadamente no hubieron heridos', 'DilmerG',1,5),
('21-11-2011','Estrenando YR!! :D', 'Rumba',1,5),
('23-11-2011','El día esta lluvioso en Santa Clara', 'Rumba',2,5),
('22-11-2011','Se reportan colas hacia la Tigra', 'Lav91',2,5),
('23-11-2011','Choque de motos en Santa Clara!!', 'Rumba',1,5),
('20-11-2011','Adelantamiento provoca desastres en matina', 'Lav91',16,5),
('17-11-2011','Mañana viernes negro!!', 'Rumba',1,5),
('18-11-2011','El sabado será un buen día para ir a la playa', 'Lav91',1,5),
('15-11-2011','Acaban de desbloquear la calle hacia orotina', 'Syrip98',1,2),
('15-11-2011','Inundacion provoca perdidas en Tortuguero', 'natY2',15,2),
('19-11-2011','Asaltan peluqueria los memes :yaoming:', 'natY2',1,2),
('19-11-2011','Hueco en carretera hacia matina por lluvias', 'Syrip98',1,2),
('17-11-2011','Derrumbe hacia Orotina', 'natY2',1,2),
('19-11-2011','Exceso de ceniza por parte del volcan Irazú', 'raizTrian',1,2),
('20-11-2011','Derrocan presidenta de Costa Rica', 'raizTrian',1,2);

-- Califica
insert into califica(id_post,nombre_publicador,puntos) values
('1','foco','50'),
('2','natY2','58'),
('7','Rumba','49'),
('12','DilmerG','52'),
('13','Lav91','51'),
('16','Lav91','50');

-- Videos
insert into video (url, fecha_hora,descripcion) values
('http://www.youtube.com/watch?v=0RHkbt6FMFg', '15-11-2011', 'Accidentes'),
('http://www.youtube.com/watch?v=4EwSAzHj8VM&feature=g-logo', '15-11-2011', 'Ray William Johnson'),
('http://www.youtube.com/watch?v=H-UIUhVores&feature=related', '15-11-2011', 'Ray William Johnson'),
('http://www.youtube.com/watch?v=djw6AJqHFOU&feature=g-logo', '15-11-2011', 'Google Search app for iPad'),
('http://www.youtube.com/watch?v=tVO8pjqwElo', '15-11-2011', 'Noticias Última Hora Noticias de España e Internacionales RTVE es'),
('http://www.youtube.com/watch?v=ekrQ0kVHy2w', '15-11-2011', 'Noticieros Televisa Noticias de hoy, reportajes en vivo, información y coberturas especiales'),
('http://www.youtube.com/watch?v=L-iepu3EtyE&ob=av2e', '15-11-2011', 'Música'),
('http://www.youtube.com/watch?v=XFkzRNyygfk', '15-11-2011', 'Música'),
('http://www.youtube.com/watch?v=rdMoRhfd1Sk&feature=player_embedded#!', '15-11-2011', 'Tecnologia'),
('http://www.youtube.com/watch?v=EhrW_4EokK8&feature=related', '15-11-2011', 'Tecnologia');

-- relacionavideos
insert into relacionavideo(id_post,id_video) values
('1','1'),
('2','2'),
('4','3'),
('7','4'),
('8','5'),
('10','1'),
('11','2');

-- perteneceequipo
insert into perteneceequipo(nombre_publicador, id_equipo) values
('DilmerG','1'),
('Rumba','1'),
('Lav91','1'),
('foco','3'),
('salDr','2'),
('natY2','4'),
('Alvar98','5');

-- Audio
insert into audio (url,fecha_hora, descripcion) values
('http://www.goear.com/files/external.swf?file=cb08abb', '16-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=e8de98f', '20-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=935d40e', '22-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=49a1aca', '21-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=e8de98f', '23-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=935d40e', '22-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=cb08abb', '21-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=cb08abb', '17-11-2011', 'musica'),
('http://www.goear.com/files/external.swf?file=cb08abb', '18-11-2011', 'musica');

-- Eventos
insert into evento (nombre, descripcion, fecha_hora, nombre_usuario, id_lugar) values
('vacaciones en la playa', 'Viaje','2-12-2011','Rumba',15),
('Reunion para el proyecto', 'Reunión','24-11-2011','natY2',2),
('Fiesta de cumpleaños', 'Cumpleaños','5-12-2011','natY2',3),
('Reunion de junta', 'Reunion','27-12-2011','desfr23',4),
('Selebracion de año nuevo', 'Año nuevo','31-12-2011','DilmerG',5),
('Matrimonio de Carnen', 'Matrinonio','8-12-2011','Lav91',6),
('Fiesta del dia del programador', 'Fiesta','16-12-2011','Lav91',7),
('Viaje a panama', 'Viaje','12-12-2011','DilmerG',8),
('Viaje a isla del coco', 'Viaje','14-12-2011','raizTrian',9),
('Fin de semana buseando', 'Busear','17-12-2011','raizTrian',10);

-- Logros
insert into logro(nombre, descripcion,requisitos,puntos) values
('Nomada','Obtienes 10 puntos extra', 'Obtener 15 puntos', 15),
('Colector','Obtienes 15 puntos extra', 'Obtener 50 puntos', 50),
('Caza pistas','Obtienes 20 puntos extra', 'Obtener 150 puntos', 150),
('Colaborador','Obtienes 50 puntos extra', 'Obtener 300 puntos', 300),
('Acechador','Obtienes 100 puntos extra', 'Obtener 600 puntos',600),
('Cazador','Obtienes 200 puntos extra', 'Obtener 1200 puntos', 1200),
('Detective','Obtienes 500 puntos extra', 'Obtener 2400 puntos', 2400),
('Agente','Obtienes 1000 puntos extra', 'Obtener 4800 puntos', 4800),
('Periodista','Obtienes 3000 puntos extra', 'Obtener 9600 puntos', 9600);

-- Comentarios
insert into comentario (fecha_hora, contenido, id_post, nombre_usuario) values
('15-11-2011',':O hubieron muertes!!?!?!',1,'Rumba'),
('15-11-2011','Afortunadamente no, solo un par de heridos',1,'DilmerG'),
('15-11-2011','Bien por ellos..',1,'raizTrian'),
('16-11-2011','A por un nuevo ipad!!',8,'natY2'),
('16-11-2011','Yo por mi cumputadora nueva XD',8,'mari21'),
('16-11-2011','Ya se donde se va a quedar todo mi aguinaldo',8,'natY2'),
('16-11-2011','Y yo sin paraguas /:',4,'DilmerG'),
('16-11-2011','Al fin!!, un dia fresco..',4,'Rumba'),
('16-11-2011','meguenga a las 5!!!',4,'mari21');

--Mensajes
insert into mensaje (fecha_hora,asunto, contenido, nombre_usuario) values
('17-11-2011', 'nuevo reloj', 'Revise este nuevo reloj que estará diponible mañana en amazon', 'raizTrian'),
('17-11-2011', 'Reunion con Andres', 'Reunion coon andreas mañana a las 900am', 'DilmerG'),
('18-11-2011', 'informe', 'Ya esta lista mi parte el informe de gira', 'Rumba'),
('18-11-2011', 'Vacasiones', 'Entra en mi blog para que veas algunos lugares que he pensado que visitemos', 'mari21'),
('18-11-2011', 'Aniversario', 'Mañana es el anicersario de google', 'raizTrian'),
('21-11-2011', 'Meguenga', 'Meguenda despues de entrega de proyecto', 'natY2'),
('21-11-2011', 'Tarea de Bases', 'La tarea de bases el para la otra semana', 'Lav91'),
('22-11-2011', 'Rolex', '¿Ya vio el rolex que estan rifando en yo reportero entre usuarios de 9000 para arriba?', 'raizTrian'),
('23-11-2011', 'Curso de surfing', 'inicia el 4 de diciembre del presente año', 'raizTrian');

-- Envia Mensaje
insert into enviamensaje values
('DilmerG',1),
('Rumba',2),
('Lav91',3),
('Rumba',4),
('Lav91',5),
('DilmerG',6),
('Rumba',7),
('natY2',8),
('Alvar98',9);


-- Regula
insert into regula values
('DilmerG',1),
('Lav91',2),
('DilmerG',3),
('DilmerG',4),
('Lav91',5),
('Rumba',6),
('Lav91',7),
('Rumba',8),
('Rumba',9),
('Lav91',10),
('Rumba',1);

-- relacionaEvento
insert into relacionaEvento values
(1,9),
(2,8),
(3,7),
(4,6),
(5,5),
(6,4),
(7,3),
(8,2),
(9,1);

-- relacionaAudio
insert into relacionaAudio values
(1,9),
(2,8),
(3,7),
(4,6),
(5,5),
(6,4),
(7,3),
(8,2),
(9,1);

-- relacionaImagen
insert into relacionaImagen values
(1,9),
(2,8),
(3,7),
(4,6),
(5,5),
(6,4),
(7,3),
(8,2),
(9,1);

-- etiqueta
insert into etiqueta(texto) values
('Fiesta'),
('Noticia'),
('Cumpleaños'),
('Accidente'),
('Anuncio');

-- relacionaEtiqueta 
insert into relacionaEtiqueta values
(1,5),
(2,4),
(3,3),
(4,2),
(5,1);

-----------------------------------------VISTAS---------------------------------------------

/*1) Mostrar las veces que un administrador ha calificado un post*/

--drop view publicadorescalificaciones
create or replace view publicadorescalificaciones
as
	select nombre_usuario, count(id_post) from publicador p inner join califica c
	on c.nombre_publicador=p.nombre_usuario
	group by nombre_usuario;

/*2) Ver el promedio de calificación de cada post */

create or replace view promcalificacionpost
as
	select id_post, s/c prom from
	(select id_post, count(id_post) c, sum(puntos) s from califica ca
	group by id_post) as parcial;

/*3) Mostrar el historial de videos que ha publicado un equipo (agrupado por nombre de equipo y
cantidad de videos publicados)*/

create or replace view historialvideosequipo
as
 	select parcial.n, parcial.ca from
 	(select e.nombre n, 0 c,posteq.c ca from equipo e full outer join
 	(select nombre,p.id_equipo ie, count(p.id_equipo)c from equipo e,post p
 	where e.id_equipo=p.id_equipo
 	group by e.nombre,ie) posteq
 	on e.id_equipo=posteq.ie) parcial;

/*4) Ver el historial de eventos de cada lugar (agrupados por lugar y número de eventos
realizados)*/

create or replace view historialeventoslugar
as
 	select il, c, parcial.ca from
 	(select id_lugar il, ciudad c, ca from lugar l full outer join
 	(select l.id_lugar l, count(e.id_evento) ca from evento e, lugar l
 	where l.id_lugar=e.id_lugar
 	group by l.id_lugar,l.ciudad) ev
 	on l.id_lugar=ev.l) parcial;

/*5) Mostrar el historial de posts con calificacion menor y mayor ó igual que 50 para cada
publicador (mostrar nombre completo y nombre de usuario para este)*/

create or replace view historialpostpublicador
as
 	select us.nombre_completo,usuario,"may=50","menor50" from
  	(select mayores.nc nombre_completo,mayores.nu usuario,mayores.ma "may=50",menores.menor "menor50" from
    ((select nombre||' '||apellido1||' '||apellido2 nc, u.nombre_usuario nu,pma.mayori ma,0 from usuario u
   	 full outer join
    (select nombre||' '||apellido1||' '||apellido2 nc, u.nombre_usuario nu,
    pc.id_post ip,count(pc.id_post) mayori from promcalificacionpost pc, usuario u, post p
    where prom>=50 and p.id_post=pc.id_post and p.nombre_usuario=u.nombre_usuario
    group by nombre||' '||apellido1||' '||apellido2,u.nombre_usuario,pc.id_post) pma
    on pma.nu=u.nombre_usuario)) mayores full outer join
    (select u.nombre_usuario nu,count(pc.id_post) menor from promcalificacionpost pc, usuario u,post p
    where prom<50 and p.id_post=pc.id_post and p.nombre_usuario=u.nombre_usuario
    group by u.nombre_usuario)menores
    on menores.nu=mayores.nu) as us, publicador p
    where p.nombre_usuario=us.usuario;


-------------------------------------------------Procedimientos y consultas-------------------------------------------------------
-- 1) seleccionar usuarios recomendados para seguir, los cuales pueden estar basados 
-- en los usuarios a los que siguen los usuarios que sigue el usuario
select recomendado from (select seguido2 recomendado, count(seguido2) coincidencias from 
		(select x.seguidor seguidor1, x.seguido seguido1, y.seguidor seguidor2 ,y.seguido seguido2 from sigue x, sigue y) ad
	where seguidor1 = 'Alvar98' and seguido1 = seguidor2
	group by recomendado)recomendos
	where coincidencias > 1;

-- 2) seleccionar usuarios recomendados para seguir, los cuales pueden estar basados en los usuarios a los que siguen los usuarios que sigue el usuario -- --(arriba la grafica)
select recomendado from (select seguido2 recomendado, count(seguido2) coincidencias from
        (select x.seguidor seguidor1, x.seguido seguido1, y.seguidor seguidor2 ,y.seguido seguido2 from sigue x, sigue y) ad
    where seguidor1 = 'Alvar98' and seguido1 = seguidor2
    group by recomendado)recomendos
    where coincidencias > 1;

--obtiene el id del post con mas cantidad de imagenes
select id_post, count(id_post)cantidad_imagenes from relacionaimagen
    group by id_post
    order by cantidad_imagenes desc limit 1

--obtiene el id del post con mas cantidad de videos
select id_post, count(id_post)cantidad_videos from relacionavideo
    group by id_post
    order by cantidad_videos desc limit 1


--obtiene el id del post con mas cantidad de archivos de audio
select id_post, count(id_post)cantidad_audio from relacionaaudio
    group by id_post
    order by cantidad_audio desc limit 1

----------------------------------------TRIGGERS--------------------------------------------

/*1) Verificar que dos eventos no se realicen en un mismo lugar a una misma hora al momento de insertar o actualizar en eventos.*/

CREATE OR REPLACE FUNCTION validareventos() RETURNS TRIGGER
AS
$trigger_validareventos$
  declare
	evento_igual int default 0;
  BEGIN
    select into evento_igual l from
    (select fecha_hora, id_lugar, count(id_lugar) l from evento
    where fecha_hora=new.fecha_hora and id_lugar=new.id_lugar
    group by fecha_hora,id_lugar) as lugares;
    
    if(evento_igual >= 1) then
   	 raise exception 'Hay al menos un evento que tiene la misma fecha y
   	 hora de inicio:%',evento_igual;
    end if;

	RETURN NEW;

  END;
$trigger_validareventos$
LANGUAGE plpgsql;

 
--drop TRIGGER triggerValidarEventos
CREATE TRIGGER triggerValidarEventos
before INSERT ON evento
	FOR EACH ROW EXECUTE PROCEDURE validareventos();

insert into evento (nombre, descripcion, fecha_hora, nombre_usuario, id_lugar) values
('vacaciones en la playa', 'Viaje','22-12-2011','Rumba',15),
('vacaciones en la playa', 'Viaje','2-12-2011','Rumba',16);

/*2) Actualizar el puntaje de cada usuario dependiendo de los videos que publique, seguidores que tenga y calificaciones en sus posts.*/

CREATE OR REPLACE FUNCTION actualizarptsusuarios() RETURNS TRIGGER
AS
$trigger_actualizarptsusuarios$
  declare
	pts_post int default 0;
	pts_video int default 0;
	pts_seguidores int default 0;
  BEGIN
    select into pts_post c from
    (select pu.nombre_usuario nu, count(pc.id_post) c from
    promcalificacionpost pc, post p, publicador pu
    where pc.id_post=p.id_post and p.nombre_usuario= pu.nombre_usuario and pc.prom>=90
    and p.nombre_usuario=new.nombre_publicador
    group by pu.nombre_usuario) ppost;
    
    select into pts_video ca from
    (select pu.nombre_usuario, count(rv.id_post) ca from relacionavideo rv, post p, publicador pu
    where rv.id_post=p.id_post and p.nombre_usuario=pu.nombre_usuario
    and pu.nombre_usuario=new.nombre_publicador
    group by pu.nombre_usuario) pvideo;

    select into pts_seguidores s from
    (select seguido, count(seguidor) s from sigue where sigue.seguido=new.nombre_publicador
    group by seguido) seguidores;
    
    update publicador set puntos=pts_video
    where nombre_usuario=new.nombre_publicador;
    
	RETURN NEW;

  END;
$trigger_actualizarptsusuarios$
LANGUAGE plpgsql;

--drop TRIGGER triggerActualizarptsusuarios
CREATE TRIGGER triggerActualizarptsusuarios
after INSERT OR UPDATE ON califica
	FOR EACH ROW EXECUTE PROCEDURE actualizarptsusuarios();
    

/*3) Verificar si el post cumple con un promedio de calificacion de al menos 95 para darle
insertar un nuevo logro al usuario que lo publicó en caso de que este no lo haya tenido
anteriormente.*/

CREATE OR REPLACE FUNCTION validarlogros() RETURNS TRIGGER
AS
$trigger_validarlogros$
  declare
	cant_post int default 0;
	pts int default 0;
  BEGIN
    select into cant_post c from
    (select u.nombre_usuario,count(pc.id_post) c from
    promcalificacionpost pc, post p,usuario u
    where pc.id_post=p.id_post and p.nombre_usuario=u.nombre_usuario and pc.prom>=95
    and u.nombre_usuario='DilmerG'
    group by u.nombre_usuario) cp;

    select into pts p from
    (select puntos p from publicador where nombre_usuario='DilmerG') pt;
    
    if(cant_post >= 1 and pts >= 9600)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'9');
   	 pts=pts+3000;
    end if;
    
    if(cant_post >=1 and pts < 9600 and pts >= 4800)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'8');
   	 pts=pts+1000;
    end if;
    
    if(cant_post >= 1 and pts < 4800 and pts >= 2400)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'7');
   	 pts=pts+500;
    end if;
    
    if(cant_post >= 1 and pts < 2400 and pts >= 1200)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'6');
   	 pts=pts+200;
    end if;
    
    if(cant_post >= 1 and pts < 1200 and pts >= 600)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'5');
   	 pts=pts+100;
    end if;
    
    if(cant_post >= 1 and pts < 600 and pts >= 300)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'4');
   	 pts=pts+50;
    end if;
    
    if(cant_post >= 1 and pts < 300 and pts >= 150)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'3');
   	 pts=pts+20;
    end if;
    
    if(cant_post >= 1 and pts < 150 and pts >= 50)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'2');
   	 pts=pts+15;
    end if;
    
    if(cant_post >= 1 and pts < 50 and pts >= 15)then
   	 insert into obtienelogro(nombre_publicador,id_logro) values
   	 (new.nombre_publicador,'1');
   	 pts=pts+10;
    end if;

    update publicador set puntos=pts where nombre_usuario=new.nombre_publicador;
    
	RETURN NEW;

  END;
$trigger_validarlogros$
LANGUAGE plpgsql;

 
--drop TRIGGER triggerValidarLogros
CREATE TRIGGER triggerValidarLogros
before INSERT OR UPDATE ON califica
	FOR EACH ROW EXECUTE PROCEDURE validarlogros();
    

/*4) Verificar cada vez que se inserta un nuevo post si el usuario que lo publicó tiene más de
80 posts publicados, si es así; se le inserta un nuevo logro a ese usuario en caso de que no
lo haya tenido anteriormente.*/

CREATE OR REPLACE FUNCTION actualizarptspost() RETURNS TRIGGER
AS
$trigger_actualizarptspost$
  declare
	pts_post int default 0;
	p_actual int default 0;
  BEGIN
    select into pts_post c from
    (select pu.nombre_usuario nu, count(p.id_post) c from post p, publicador pu
    where p.nombre_usuario= pu.nombre_usuario
    and p.nombre_usuario=new.nombre_usuario
    group by pu.nombre_usuario) ppost;
    
    update publicador set puntos=puntos+pts_post
    where nombre_usuario=new.nombre_usuario;

    select into p_actual p from
    (select puntos p from publicador where nombre_usuario=new.nombre_usuario) pt;

    if(p_actual>=80)then
   	 insert into obtienelogro(nombre_usuario,id_logro) values
   	 (new.nombre_publicador,'1');
   	 update publicador set puntos=puntos+10;
    end if;
    
	RETURN NEW;

  END;
$trigger_actualizarptspost$
LANGUAGE plpgsql;

--drop TRIGGER triggerActualizarptspost
CREATE TRIGGER triggerActualizarptspost
after INSERT ON post
	FOR EACH ROW EXECUTE PROCEDURE actualizarptspost();

------------------------------------------CURSORES------------------------------------

/* 1) Se encarga de actualizar los valores de puntos del usuario basado en el número de
seguidores*/

create or replace function Actualizarpuntos() returns void
as
$actualizar$
    declare
    --declaración del cursor
    vcursor CURSOR FOR
    select nombre_usuario,puntos from publicador;
    --variables que almacenarán los resultados del cursor en cada lectura de tupla realizada
    usuario varchar;
    pts int default 0;

    begin
       --inicializa el cursor
       open vcursor;
       --realiza la primer lectura y se posiciona en la primer tupla del resultado
       fetch vcursor into usuario,pts;
       --found: variable que indica si ha sido posible leer un siguiente registro
       while found loop
       --calcula el total de créditos correspondiente a la matrícula actual donde se posiciona cursor

   select into pts s from
   (select seguido, count(seguidor) s from sigue where sigue.seguido=usuario
   group by seguido) seguidores;
           
           update publicador set puntos= puntos+pts;
           --Lee y se posiciona en la siguiente tupla del resultado
           fetch vcursor into usuario,pts;
       end loop;
       --cierra el cursor
       close vcursor;
    end;
$actualizar$
language plpgsql;-- ejecución de la función que lanza el cursor
select Actualizarpuntos();

--comprobación de los cambios
select * from publicador

/* 2) Se encarga de actualizar los valores de puntos del usuario basado en el número de
seguidores*/

create or replace function LlenarObtieneLogro() returns void
as
$actualizar$
    declare
    --declaración del cursor
    vcursor CURSOR FOR
    select id_post,nombre_usuario from post;
    --variables que almacenarán los resultados del cursor en cada lectura de tupla realizada
    post int;
    usuario varchar;
    posts int default 0;

    begin
       --inicializa el cursor
       open vcursor;
       --realiza la primer lectura y se posiciona en la primer tupla del resultado
       fetch vcursor into post,usuario;
       --found: variable que indica si ha sido posible leer un siguiente registro
       while found loop
       --calcula el total de créditos correspondiente a la matrícula actual donde se posiciona cursor

   --select into posts s from
   --(select nombre_usuario, count(id_post) s from post where nombre_usuario=usuario
   --group by nombre_usuario) p;

   update publicador set puntos=puntos;    
   update obtienelogro set nombre_publicador=usuario;
           --Lee y se posiciona en la siguiente tupla del resultado
           fetch vcursor into post,usuario;
       end loop;
       --cierra el cursor
       close vcursor;
    end;
$actualizar$
language plpgsql;
-- ejecución de la función que lanza el cursor
select LlenarObtieneLogro();

--comprobación de los cambios
select * from obtienelogro


