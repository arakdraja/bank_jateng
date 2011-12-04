USE bjt;

/* __grup_user */
insert into __grup_user (NAMA_GRUP, KETERANGAN_GRUP) values ('Administrator', 'Sistem Administrator');
insert into __grup_user (NAMA_GRUP, KETERANGAN_GRUP) values ('Unit I', '');
insert into __grup_user (NAMA_GRUP, KETERANGAN_GRUP) values ('Unit II', '');

/* __user */
insert into __user values ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '1');
insert into __user values ('unit1', 'a7f4909446e1cc8286ceae47afe6ccb698af99769be9c5b4a7fa0aa7cc37667f', '1');
insert into __user values ('unit2', '0efab319cc113a698ba482dd00dab8c25ee5537c2f974dc8cdc1c2fffdad46c7', '1');

/* __user_grup */
insert into __user_grup values ('admin', 1);
insert into __user_grup values ('admin', 2);
insert into __user_grup values ('admin', 3);
insert into __user_grup values ('unit1', 2);
insert into __user_grup values ('unit2', 3);

/* __MENU */
insert into __menu values ('01','Aplikasi','app','0',1,'01','00','app','1');
insert into __menu values ('01.01','Beranda','app_home','1',2,'01.01','01','beranda','1');
insert into __menu values ('01.02','Pengaturan User','app_adm_user','1',2,'01.02','01','users','1');
insert into __menu values ('01.03','Pengaturan Hak Akses','app_adm','1',2,'01.03','01','users','1');
insert into __menu values ('02','Referensi Data','ref','0',1,'02','00','module','1');
insert into __menu values ('02.01','Jenis Barang','ref_jenis_barang','1',2,'02.01','02','menu_leaf','1');
insert into __menu values ('03','Master Data','master','0',1,'03','00','module','1');
insert into __menu values ('03.01','Barang','master_barang','1',2,'03.01','03','menu_leaf','1');
insert into __menu values ('04','Permintaan Barang','permintaan','0',1,'04','00','module','1');
insert into __menu values ('04.01','Permintaan Barang','permintaan_barang','1',2,'04.01','04','menu_leaf','1');
insert into __menu values ('05','Pengeluaran Barang','pengeluaran','0',1,'05','00','module','1');
insert into __menu values ('05.01','Pengeluaran Barang','pengeluaran_barang','1',2,'05.01','05','menu_leaf','1');

/* __hak_akses */
/* administrator */
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'01','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'01.01','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'01.02','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'01.03','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'02','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'02.01','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'03','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'03.01','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'04','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'04.01','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'05','4');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (1,'05.01','4');
/* unit I */
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (2,'04','3');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (2,'04.01','3');
/* unit II */
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (3,'03','3');
insert into __hak_akses (ID_GRUP, MENU_ID, HA_LEVEL) values (3,'03.01','3');
