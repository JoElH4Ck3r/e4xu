////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.gui.renderers 
{
	/**
	 * IBranchRenderer interface.
	 * @author wvxvw
	 */
	public interface IBranchRenderer extends IRenderer
	{
		function get closedHeight():int;
		
		function get opened():Boolean;
		function set opened(value:Boolean):void;
		
		function set leafLabelFunction(value:Function):void;
		
		function set leafLabelField(value:String):void;
		
		function set folderIcon(value:Class):void;
		
		function set closedIcon(value:Class):void;
		
		function set openIcon(value:Class):void;
		
		function set docIconFactory(value:Function):void;
		
		function set folderFactory(value:Function):void;
		
		function nodeToRenderer(node:XML):IRenderer;
		
		function rendererToXML(renderer:IRenderer):XML;
		
		function indexForItem(item:IRenderer):int;
	}
	
}