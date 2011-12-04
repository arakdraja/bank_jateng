/**
 *
 * Author(s):
 * + x10c-Lab
 *   - agus sugianto (agus.delonge@gmail.com)
 */

var m_app_home;
var m_app_home_d		= _g_root +'/module/app_home/';

function M_HomeLog()
{
	this.store = new Ext.data.ArrayStore({
		url			:m_app_home_d +'data_log.jsp'
	,	fields		:[
			'date'
		,	'user'
		,	'menu'
		,	'stat'
		]
	,	autoLoad	:false
	});

	this.store_stat = new Ext.data.ArrayStore({
		fields		:['id','name']
	,	idIndex		:0
	,	data		:[
			[2, 'Insert']
		,	[3, 'Update']
		,	[4, 'Delete']
		,	[5, 'Login']
		]
	});

	this.store_menu = new Ext.data.ArrayStore({
		fields		:['id','name']
	,	idIndex		:0
	,	url			:m_app_home_d +'data_menu.jsp'
	,	autoLoad	:false
	});

	this.cm = new Ext.grid.ColumnModel({
		columns	:[
			new Ext.grid.RowNumberer()
		,{
			header		:'Tanggal'
		,	dataIndex	:'date'
		,	align		:'center'
		,	width		:160
		},{
			header		:'User'
		,	dataIndex	:'user'
		,	width		:180
		},{
			header		:'Nama Menu'
		,	id			:'menu'
		,	dataIndex	:'menu'
		,	width		:240
		,	renderer	:store_renderer("id", "name", this.store_menu)
		},{
			header		:'Status'
		,	dataIndex	:'stat'
		,	align		:'center'
		,	width		:60
		,	renderer	:store_renderer("id", "name", this.store_stat)
		}]
	});

	this.grid = new Ext.grid.GridPanel({
		region				:"center"
	,	store				:this.store
	,	autoScroll			:true
	,	cm					:this.cm
	,	stripeRows			:true
	,	autoExpandColumn	:'menu'
	});
/*
 */
	this.form_date_bgn = new Ext.form.DateField({
		fieldLabel	:"Dari tanggal"
	,	format		:"Y-m-d"
	});

	this.form_date_end = new Ext.form.DateField({
		fieldLabel	:"sampai dengan"
	,	format		:"Y-m-d"
	});

	this.fs_date = new Ext.form.FieldSet({
		title		:"Filter Tanggal"
	,	labelWidth	:120
	,	items		:[
			this.form_date_bgn
		,	this.form_date_end
		]
	});

	this.form_user = new Ext.form.TextField({
		fieldLabel		:"User"
	});

	this.form_menu = new Ext.form.ComboBox({
		fieldLabel		:"Menu"
	,	store			:this.store_menu
	,	valueField		:'id'
	,	displayField	:'name'
	,	triggerAction	:'all'
	,	mode			:'local'
	,	typeAhead		:true
	,	listWidth		:300
	});

	this.form_stat = new Ext.form.ComboBox({
		fieldLabel		:"Status"
	,	store			:this.store_stat
	,	valueField		:'id'
	,	displayField	:'name'
	,	triggerAction	:'all'
	,	mode			:'local'
	,	typeAhead		:true
	});

	this.btn_filter = new Ext.Button({
		text	:"Filter"
	,	iconCls	:"refresh16"
	,	scope	:this
	,	handler	:function() {
			this.do_filter();
		}
	});

	this.form = new Ext.FormPanel({
		title		:"Filter Log"
	,	region		:"north"
	,	labelAlign	:"right"
	,	padding		:10
	,	autoScroll	:true
	,	autoHeight	:true
	,	collapsible	:true
	,	items		:[
			this.fs_date
		,	this.form_user
		,	this.form_menu
		,	this.form_stat
		]
	,	buttonAlign	:"center"
	,	buttons		:[
			this.btn_filter
		]
	});
/*
 * main panel
 */
	this.panel = new Ext.Panel({
		title		:'Sistem Log'
	,	layout		:"border"
	,	items		:[
			this.form
		,	this.grid
		]
	});
/*
 * functions
 */
	this.do_filter = function()
	{
		this.store.load({
			scope	: this
		,	params	: {
				date_bgn	:this.form_date_bgn.getValue()
			,	date_end	:this.form_date_end.getValue()
			,	user		:this.form_user.getValue()
			,	menu		:this.form_menu.getValue()
			,	stat		:this.form_stat.getValue()
			}
		});
	}

	this.do_refresh = function(ha_level) {
		if (ha_level == 4) {
			this.store_menu.load({
				scope		:this
			,	callback	: function(r,o,s) {
					this.store.load();
				}
			});
		}
	}
}

function M_HomeWinChange(title, form_old_title, form_new_title, form_new_confirm_title, form_type, url)
{
	this.type	= form_type;
	this.url	= url;

	this.form_old = new Ext.form.TextField({
			fieldLabel	:form_old_title
		,	inputType	:form_type
		,	width		:200
		});

	this.form_new = new Ext.form.TextField({
			fieldLabel	:form_new_title
		,	inputType	:form_type
		,	allowBlank	:false
		,	width		:200
		});

	this.form_new_confirm = new Ext.form.TextField({
			fieldLabel	:form_new_confirm_title
		,	inputType	:form_type
		,	allowBlank	:false
		,	width		:200
		});

	this.btn_cancel = new Ext.Button({
			text	:'Batal'
		,	iconCls	:'del16'
		,	scope	:this
		,	handler	:function() {
				this.do_cancel();
			}
	});

	this.btn_save = new Ext.Button({
			text		: 'Simpan'
		,	iconCls		: 'save16'
		,	scope		: this
		,	handler		: function() {
				this.do_save();
			}
		});

	this.win = new Ext.Window({
		title		:title
	,	modal		:true
	,	layout		:'form'
	,	labelAlign	:'left'
	,	iconCls		:'password16'
	,	padding		:6
	,	closable	:false
	,	resizable	:false
	,	plain		:true
	,	autoHeight	:true
	,	width		:340
	,	items		:[
			this.form_old
		,	this.form_new
		,	this.form_new_confirm
		]
	,	bbar		: [
			this.btn_cancel, '->'
		,	this.btn_save
		]
	});

	this.do_cancel = function()
	{
		this.win.hide();
	}

	this.is_form_valid = function()
	{
		if (this.type == 'password') {
			if (!this.form_old.isValid()) {
				Ext.Msg.alert('Kesalahan', 'Data yang anda inputkan kosong atau tidak sesuai format yang ditentukan!');
				return false;
			}
		}
		
		if (!this.form_new.isValid()) {
			Ext.Msg.alert('Kesalahan', 'Data yang anda inputkan kosong atau tidak sesuai format yang ditentukan!');
			return false;
		}

		if (!this.form_new_confirm.isValid()) {
			Ext.Msg.alert('Kesalahan', 'Data yang anda inputkan kosong atau tidak sesuai format yang ditentukan!');
			return false;
		}

		if (this.form_new.getValue() != this.form_new_confirm.getValue()) {
			Ext.Msg.alert('Kesalahan', 'Kata Kunci Baru tidak sesuai dengan Konfirmasinya!');
			return false;
		}
		
		return true;
	}

	this.do_save = function(record)
	{
		if (!this.is_form_valid()) {
			return;
		}

		var lama_v	= this.form_old.getValue();
		var baru_v	= this.form_new.getValue();
		var lama	= ''
		var baru	= '';

		if (this.type == 'password') {
			lama	= Sha256.hash(lama_v);
			baru	= Sha256.hash(baru_v);
		} else {
			lama	= lama_v;
			baru	= baru_v;
		}

		Ext.Ajax.request({
			params  :{
				lama	: lama
			,	baru	: baru
			}
		,	url		:this.url
		,	scope	:this
		,	waitMsg	:'Mohon Tunggu ...'
		,	success :function (response) {
				var msg = Ext.util.JSON.decode(response.responseText);

				if (msg.success == false) {
					Ext.MessageBox.alert('Pesan Kesalahan'
							, msg.info);
					return;
				}

				if (this.type == 'email') {
					_g_usermail = baru;
				}

				this.win.hide();
			}
		});
	}
}

function M_Home()
{
	this.win_pass = new M_HomeWinChange(
			'Penggantian Kata Kunci'
		,	'Kata Kunci Lama'
		,	'Kata Kunci Baru'
		,	'Konfirmasi Kata Kunci Baru'
		,	'password'
		,	m_app_home_d +'submit_change_password.jsp'
		);

	this.menu = new Ext.menu.Menu({
		items	:[
			{
				text	: 'Ganti Kata Kunci'
			,	iconCls	: 'password16'
			,	scope	: this
			,	handler	: function (b,e) {
					this.do_change_password()
				}
			}
		]
	});

	this.btn_my_account = new Ext.SplitButton({
		text	:'My Account'
	,	iconCls	: 'account16'
	,	menu	: this.menu
	});

	this.panel_log = new M_HomeLog();

	this.panel_home = new Ext.Panel({
		title			:"Home"
	,	padding			:"6"
	,	tbar			:[
			this.btn_my_account
		]
	,	defaults		:{margins:'0 auto 12 auto'}
	,	items			:[
			//this.data_obs.panel
		]
	});
	
	this.panel = new Ext.TabPanel({
		id				:'app_home_panel'
	,	activeTab		:0
	,	autoScroll		:true
	,	bodyBorder		:false
	,	frame			:false
	,	items			:[
			this.panel_home
		,	this.panel_log.panel
		]
	});

	this.do_change_password = function()
	{
		this.win_pass.win.show();
	}

	this.do_refresh = function(ha_level)
	{
		this.panel_log.do_refresh(ha_level);
		
		if (_g_ha < 4) {
			this.panel.hideTabStripItem(1);
		} else {
			this.panel.unhideTabStripItem(1);
		}
		
		this.panel.setActiveTab(0);
	}
}

m_app_home = new M_Home();

//@ sourceURL=app_home.layout.js
