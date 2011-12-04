/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     12/4/2011 5:20:07 PM                         */
/*==============================================================*/

/*==============================================================*/
/* Table: M_BARANG                                              */
/*==============================================================*/
create table M_BARANG
(
   KODE_BARANG          varchar(30) not null,
   ID_JENIS_BARANG      smallint unsigned not null,
   NAMA_BARANG          varchar(100) not null,
   JUMLAH_BAIK          int unsigned not null default 0,
   JUMLAH_RUSAK_RINGAN  int unsigned not null default 0,
   JUMLAH_RUSAK_BERAT   int unsigned not null default 0,
   JUMLAH_TOTAL         int unsigned not null,
   STOK_MINIMAL         int unsigned not null,
   KETERANGAN           varchar(250) default '',
   primary key (KODE_BARANG)
);

/*==============================================================*/
/* Table: R_JENIS_BARANG                                        */
/*==============================================================*/
create table R_JENIS_BARANG
(
   ID_JENIS_BARANG      smallint unsigned not null auto_increment,
   NAMA_JENIS_BARANG    varchar(250) not null,
   primary key (ID_JENIS_BARANG)
);

/*==============================================================*/
/* Table: T_PERMINTAAN_BARANG                                   */
/*==============================================================*/
create table T_PERMINTAAN_BARANG
(
   ID_PERMINTAAN_BARANG bigint unsigned not null,
   JENIS_PERMINTAAN_BARANG char(1) not null comment '1 = persediaan; 2 = kebutuhan insidentil',
   STATUS_PERMINTAAN_BARANG char(1) not null default '1' comment '1 = dalam proses; 2 = disetujui; 3 = ditolak',
   primary key (ID_PERMINTAAN_BARANG)
);

/*==============================================================*/
/* Table: T_PERMINTAAN_BARANG_DETAIL                            */
/*==============================================================*/
create table T_PERMINTAAN_BARANG_DETAIL
(
   ID_PERMINTAAN_BARANG bigint unsigned not null,
   KODE_BARANG          varchar(30) not null,
   JUMLAH_PERMINTAAN_BARANG int unsigned not null default 0,
   primary key (ID_PERMINTAAN_BARANG, KODE_BARANG)
);

/*==============================================================*/
/* Table: __GRUP_USER                                           */
/*==============================================================*/
create table __GRUP_USER
(
   ID_GRUP              smallint unsigned not null auto_increment,
   NAMA_GRUP            varchar(100) not null,
   KETERANGAN_GRUP      varchar(250) default '',
   primary key (ID_GRUP)
);

/*==============================================================*/
/* Index: __GRUP_USER_UK                                        */
/*==============================================================*/
create unique index __GRUP_USER_UK on __GRUP_USER
(
   NAMA_GRUP
);

/*==============================================================*/
/* Table: __HAK_AKSES                                           */
/*==============================================================*/
create table __HAK_AKSES
(
   HA_ID                bigint unsigned not null auto_increment,
   ID_GRUP              smallint unsigned not null,
   MENU_ID              varchar(5) not null,
   HA_LEVEL             tinyint unsigned not null default 0 comment '0 = tidak ada akses; 1 = view; 2 = insert; 3 = update; 4 = delete',
   primary key (HA_ID)
);

/*==============================================================*/
/* Table: __LOG                                                 */
/*==============================================================*/
create table __LOG
(
   TANGGAL              timestamp not null default CURRENT_TIMESTAMP,
   ID_USER              varchar(20) not null,
   NAMA_MENU            varchar(100) not null,
   STATUS_AKSES         char(1) not null comment '2 = insert; 3 = update; 4 = delete; 5 = login',
   primary key (TANGGAL)
);

/*==============================================================*/
/* Table: __MENU                                                */
/*==============================================================*/
create table __MENU
(
   MENU_ID              varchar(5) not null,
   MENU_NAME            varchar(100) not null,
   MENU_FOLDER          varchar(100),
   MENU_LEAF            char(1) default '1' comment '0 = not leaf; 1 = leaf',
   MENU_LEVEL           smallint unsigned default 0,
   MENU_KD              varchar(25) default NULL,
   MENU_PARENT          varchar(100) not null,
   ICON                 varchar(20),
   MENU_STATUS          char(1) default '1' comment '0 = tidak aktif; 1 = aktif',
   primary key (MENU_ID)
);

/*==============================================================*/
/* Table: __USER                                                */
/*==============================================================*/
create table __USER
(
   ID_USER              varchar(20) not null,
   PASSWORD             varchar(100) not null,
   STATUS_USER          char(1) not null default '1' comment '0 = tidak aktif; 1 = aktif',
   primary key (ID_USER)
);

/*==============================================================*/
/* Table: __USER_GRUP                                           */
/*==============================================================*/
create table __USER_GRUP
(
   ID_USER              varchar(20) not null,
   ID_GRUP              smallint unsigned not null,
   primary key (ID_USER, ID_GRUP)
);

alter table M_BARANG add constraint FK_R_JENIS_BARANG_M_BARANG foreign key (ID_JENIS_BARANG)
      references R_JENIS_BARANG (ID_JENIS_BARANG) on delete restrict on update restrict;

alter table T_PERMINTAAN_BARANG_DETAIL add constraint FK_M_BARANG_T_PERMINTAAN_BARANG_DETAIL foreign key (KODE_BARANG)
      references M_BARANG (KODE_BARANG) on delete restrict on update restrict;

alter table T_PERMINTAAN_BARANG_DETAIL add constraint FK_T_PERMINTAAN_BARANG_T_PERMINTAAN_BARANG_DETAIL foreign key (ID_PERMINTAAN_BARANG)
      references T_PERMINTAAN_BARANG (ID_PERMINTAAN_BARANG) on delete restrict on update restrict;

alter table __HAK_AKSES add constraint FK___GRUP_USER___HAK_AKSES foreign key (ID_GRUP)
      references __GRUP_USER (ID_GRUP) on delete restrict on update restrict;

alter table __HAK_AKSES add constraint FK___MENU___HAK_AKSES foreign key (MENU_ID)
      references __MENU (MENU_ID) on delete restrict on update restrict;

alter table __LOG add constraint FK___USER___LOG foreign key (ID_USER)
      references __USER (ID_USER) on delete restrict on update restrict;

alter table __USER_GRUP add constraint FK___GRUP_USER___USER_GRUP foreign key (ID_GRUP)
      references __GRUP_USER (ID_GRUP) on delete restrict on update restrict;

alter table __USER_GRUP add constraint FK___USER___USER_GRUP foreign key (ID_USER)
      references __USER (ID_USER) on delete restrict on update restrict;

