/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Manages editor services
*/
component accessors="true" threadSafe singleton{

	// The structure that keeps the editors
	property name="editors"		type="struct";
	// The structure that keeps the markup languages
	property name="markups"		type="struct";
	// Setting Servie
	property name="settingService" inject="settingService@cb";
	
	/**
	* Constructor
	* @wirebox.inject wirebox
	*/
	EditorService function init(required wirebox){
		// init editors and markups
		editors = {};
		markups = [];
		
		// store factory
		variables.wirebox = arguments.wirebox;
		
		// register core editors
		registerEditor( arguments.wirebox.getInstance("CKEditor@cb") );
		registerEditor( arguments.wirebox.getInstance("EditAreaEditor@cb") );
		registerEditor( arguments.wirebox.getInstance("TextareaEditor@cb") );
		
		// register default markup
		registerMarkup( "HTML" );
		return this;
	}
	
	/**
	* Get the default system editor
	*/
	function getDefaultEditor(){
		return settingService.getSetting( "cb_editors_default" );
	}
	
	/**
	* Get the default system markup
	*/
	function getDefaultMarkup(){
		return settingService.getSetting( "cb_editors_markup" );
	}

	/**
	* Register a new editor in ContentBox
	*/
	EditorService function registerEditor(required contentbox.model.ui.editors.IEditor editor){
		editors[ arguments.editor.getName() ] = arguments.editor;	
		return this;
	}
	
	/**
	* Register a new markup in ContentBox
	*/
	EditorService function registerMarkup(required string markup){
		arrayAppend( markups, arguments.markup );	
		return this;
	}
	
	/**
	* UnRegister an editor in ContentBox
	*/
	EditorService function unRegisterEditor(required name){
		structDelete( editors, arguments.name );	
		return this;
	}
	
	/**
	* UnRegister a markup in ContentBox
	*/
	EditorService function unRegisterMarkup(required string markup){
		arrayDeleteAt( markups, arrayFindNoCase( markups, arguments.markup ) );
		return this;
	}
	
	/**
	* Get an array of registered editor names in alphabetical order
	*/
	array function getRegisteredEditors(){
		return listToArray( listSort( structKeyList( editors ), "textnocase" ) );
	}
	
	/**
	* Get an array of registered markup names in alphabetical order
	*/
	array function getRegisteredMarkups(){
		arraySort( markups, "textnocase" );
		return markups;
	}
	
	/**
	* Get an array of registered editor names in alphabetical order with their display names
	*/
	array function getRegisteredEditorsMap(){
		var aEditors = getRegisteredEditors();
		var result = [];
		for( var thisEditor in aEditors ){
			arrayAppend( result, { name=thisEditor, displayName=editors[ thisEditor ].getDisplayName() } );
		}
		return result;
	}
	
	/**
	* Get a registered editor instance
	*/
	contentbox.model.ui.editors.IEditor function getEditor(required name){
		return editors[ arguments.name ];
	}

}
