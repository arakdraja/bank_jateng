/**
 *
 * Author(s):
 * + x10c-Lab
 *   - agus sugianto (agus.delonge@gmail.com)
 */

var m_master_barang;
var m_master_barang_d = _g_root +'/module/master_barang/';

function M_MasterBarang(title)
{
	this.title		= title;
	this.dml_type	= 0;
	this.ha_level	= 0;

	this.record = new Ext.data.Record.create([
			{ name	: 'kode_barang' }
		,	{ name	: 'id_jenis_barang' }
		,	{ name	: 'nama_barang' }
		,	{ name	: 'jumlah_total' }
		,	{ name	: 'stok_minimal' }
		,	{ name	: 'keterangan' }
	]);

	this.store = new Ext.data.ArrayStore({
			fields		: this.record
		,	url			: m_master_barang_d +'data.jsp'
		,	autoLoad	: false
	});
	
	this.store_jenis_barang = new Ext.data.ArrayStore({
			fields		: ['id','name']
		,	url			: m_master_barang_d +'data_jenis_barang.jsp'
		,	idIndex		: 0
		,	autoLoad	: false
	});

	this.form_kode_barang = new Ext.form.TextField({
		allowBlank	: false
	});

	this.form_jenis_barang = new Ext.form.ComboBox({
			store			: this.store_jenis_barang
		,	valueField		: 'id'
		,	displayField	: 'name'
		,	mode			: 'local'
		,	allowBlank		: false
		,	forceSelection	: true
		,	typeAhead		: true
		,	triggerAction	: 'all'
		,	selectOnFocus	: true
	});

	this.form_nama_barang = new Ext.form.TextField({
		allowBlank	: false
	});

	this.form_jumlah_total = new Ext.form.NumberField({
			allowBlank		: false
		,	allowDecimals	: false
		,	allowNegative	: false
	});

	this.form_stok_minimal = new Ext.form.NumberField({
			allowBlank		: false
		,	allowDecimals	: false
		,	allowNegative	: false
	});

	this.form_keterangan = new Ext.form.TextField();

	this.filters = new Ext.ux.grid.GridFilters({
			encode	: true
		,	local	: true
	});

	this.columns = [
			new Ext.grid.RowNumberer()
		,	{ header		: 'Kode Barang'
			, dataIndex		: 'kode_barang'
			, sortable		: true
			, editor		: this.form_kode_barang
			, width			: 100
			, filterable	: true
			}
		,	{ header		: 'Jenis Barang'
			, dataIndex		: 'id_jenis_barang'
			, sortable		: true
			, editor		: this.form_jenis_barang
			, renderer		: combo_renderer(this.form_jenis_barang)
			, width			: 150
			, filter		: {
					type		: 'list'
				,	store		: this.store_jenis_barang
				,	labelField	: 'name'
				,	phpMode		: false
			 }
			}
		,	{ header		: 'Nama Barang'
			, dataIndex		: 'nama_barang'
			, sortable		: true
			, editor		: this.form_nama_barang
			, width			: 200
			, filterable	: true
			}
		,	{ header		: 'Jumlah'
			, dataIndex		: 'jumlah_total'
			, sortable		: true
			, editor		: this.form_jumlah_total
			, align			: 'center'
			, width			: 75
			, filter		: 
				{
					type		: 'numeric'
				}
			}
		,	{ header		: 'Stok Minimal'
			, dataIndex		: 'stok_minimal'
			, sortable		: true
			, editor		: this.form_stok_minimal
			, align			: 'center'
			, width			: 100
			, filter		: 
				{
					type		: 'numeric'
				}
			}
		,	{ id			: 'keterangan'
			, header		: 'Keterangan'
			, dataIndex		: 'keterangan'
			, sortable		: true
			, editor		: this.form_keterangan
			, filterable	: true
			}
	];

	this.sm = new Ext.grid.RowSelectionModel({
			singleSelect	: true
		,	listeners	: {
				scope		: this
			,	selectionchange	: function(sm) {
					var data = sm.getSelections();
					if (data.length && this.ha_level == 4) {
						this.btn_del.setDisabled(false);
					} else {
						this.btn_del.setDisabled(true);
					}
				}
			}
	});

	this.editor = new MyRowEditor(this);

	this.btn_ref = new Ext.Button({
			text	: 'Refresh'
		,	iconCls	: 'refresh16'
		,	scope	: this
		,	handler	: function() {
				this.do_load();
			}
	});

	this.btn_add = new Ext.Button({
			text	: 'Tambah'
		,	iconCls	: 'add16'
		,	scope	: this
		,	handler	: function() {
				this.do_add();
			}
	});

	this.btn_del = new Ext.Button({
			text		: 'Hapus'
		,	iconCls		: 'del16'
		,	disabled	: true
		,	scope		: this
		,	handler		: function() {
				this.do_del();
			}
	});

	this.toolbar = new Ext.Toolbar({
		items	: [
			this.btn_ref
		,	'-'
		,	this.btn_add
		,	'-'
		,	this.btn_del
		]
	});

	this.panel = new Ext.grid.GridPanel({
			id			: 'master_barang_panel'
		,	title		: this.title
		,	store		: this.store
		,	sm			: this.sm
		,	columns		: this.columns
		,	stripeRows	: true
		,	columnLines	: true
		,	plugins		: [this.editor, this.filters]
		,	tbar		: this.toolbar
		,	autoExpandColumn: 'keterangan'
		,	listeners	: {
					scope		: this
				,	rowclick	:
						function (g, r, e) {
							return this.do_edit(r);
						}
			}
	});

	this.set_disabled = function()
	{
		this.btn_ref.setDisabled(true);
		this.btn_add.setDisabled(true);
		this.btn_del.setDisabled(true);
	}

	this.set_enabled = function()
	{
		this.btn_ref.setDisabled(false);
		this.btn_add.setDisabled(false);
		this.btn_del.setDisabled(false);
	}

	this.set_button = function()
	{
		if (this.ha_level >= 2) {
			this.btn_add.setDisabled(false);
		} else {
			this.btn_add.setDisabled(true);
		}

		if (this.ha_level == 4) {
			this.btn_del.setDisabled(false);
		} else {
			this.btn_del.setDisabled(true);
		}
	}

	this.do_refresh = function(ha_level)
	{
		this.ha_level = ha_level;

		if (this.ha_level < 1) {
			Ext.MessageBox.alert('Hak Akses', 'Maaf, Anda tidak memiliki hak akses untuk melihat menu ini!');
			this.panel.setDisabled(true);
			return;
		} else {
			this.panel.setDisabled(false);
		}

		this.do_load();
	}

	this.do_add = function()
	{
		this.record_new = new this.record({
				kode_barang		: ''
			,	id_jenis_barang	: ''
			,	nama_barang		: ''
			,	jumlah_total	: ''
			,	stok_minimal	: ''
			,	keterangan		: ''
			});

		this.editor.stopEditing();
		this.store.insert(0, this.record_new);
		this.sm.selectRow(0);
		this.editor.startEditing(0);

		this.dml_type = 2;
		
		this.set_disabled();
	}

	this.do_edit = function(row)
	{
		if (this.ha_level >= 3) {
			this.dml_type = 3;
			return true;
		}
		return false;
	}

	this.do_del = function()
	{
		var data = this.sm.getSelections();
		if (!data.length) {
			return;
		}

		Ext.MessageBox.confirm('Konfirmasi', 'Hapus Data?', function(btn, text){
			if (btn == 'yes'){
				this.dml_type = 4;
				this.do_save(data[0]);
			}
		}, this);
	}

	this.do_save = function(record)
	{
		this.set_enabled();
		
		if (this.ha_level < 2){
			Ext.Msg.alert("Perhatian", "Maaf, Anda tidak memiliki hak akses untuk melakukan proses ini!");
			this.do_load();
			return;
		}

		Ext.Ajax.request({
				params  : {
						kode_barang		: record.data['kode_barang']
					,	id_jenis_barang	: record.data['id_jenis_barang']
					,	nama_barang		: record.data['nama_barang']
					,	jumlah_total	: record.data['jumlah_total']
					,	stok_minimal	: record.data['stok_minimal']
					,	keterangan		: record.data['keterangan']
					,	dml_type		: this.dml_type
				}
			,	url		: m_master_barang_d +'submit.jsp'
			,	waitMsg	: 'Mohon Tunggu ...'
			,	success :
					function (response)
					{
						var msg = Ext.util.JSON.decode(response.responseText);

						if (msg.success == false) {
							Ext.MessageBox.alert('Pesan', msg.info);
						}

						this.do_load();
					}
			,	scope	: this
		});
	}

	this.do_cancel = function()
	{
		this.set_enabled();
		
		if (this.dml_type == 2) {
			this.store.remove(this.record_new);
			this.sm.selectRow(0);
		}
		
		this.set_button();
	}

	this.do_load = function()
	{
		this.store_jenis_barang.load({
				callback	: function(){
					this.store.load();
				}
			,	scope		: this
		});
		
		this.set_button();
	}
}

m_master_barang = new M_MasterBarang('Master Barang');

//@ sourceURL=m_master_barang.layout.js
