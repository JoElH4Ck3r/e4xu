package tests
{
	import org.wvxvws.gui.containers.TiledPanel;
	import org.wvxvws.gui.DIV;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.managers.DragManager;
	import org.wvxvws.gui.renderers.ImageRenderer;
	
	public class TiledPanelTest extends DIV
	{
		public var data:XML = 
		<data>
			<test src="resources/blood300.jpg"/>
			<test src="resources/clock.jpg"/>
			<test src="resources/corsair.gif"/>
			<test src="resources/fly.gif"/>
			<test src="resources/moghican.jpg"/>
			<test src="resources/moghican.jpg"/>
			<test src="resources/moghican.jpg"/>
			<test src="resources/moghican.jpg"/>
			<test src="resources/moghican.jpg"/>
			<test src="resources/moghican.jpg"/>
		</data>;
		
		public var testPanel:TiledPanel = new TiledPanel();
		
		private var _lastActiveRenderer:DisplayObject;
		private var _lastActiveIndex:int;
		
		public function TiledPanelTest()
		{
			super();
			width = 800;
			height = 600;
			super.initialized(null, null);
			testPanel.width = 100;
			testPanel.height = 100;
			testPanel.rendererFactory = ImageRenderer;
			testPanel.dataProvider = data;
			testPanel.addEventListener(GUIEvent.CHILDREN_CREATED, childrenCreatedHandler);
			testPanel.initialized(this, null);
		}
		
		private function childrenCreatedHandler(event:Event):void 
		{
			data.*.(addRendererHandlers(valueOf()));
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function addRendererHandlers(xml:XML):void
		{
			var renderer:DisplayObject = testPanel.getItemForNode(xml);
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, renderer_mouseDownHandler);
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void 
		{
			var overRow:int = testPanel.mouseX / testPanel.cellSize.x;
			var overColumn:int = testPanel.mouseY / testPanel.cellSize.y;
			var newItemPosition:int = testPanel.rowCount * overColumn + overRow - 1;
			if (newItemPosition < 0) newItemPosition = 0;
			if (newItemPosition > data.*.length() - 1) newItemPosition = data.*.length() - 1;
			DragManager.drop();
			var currentNode:XML = testPanel.getNodeForItem(_lastActiveRenderer);
			data.insertChildAfter(data.*[newItemPosition], currentNode);
			_lastActiveRenderer.visible = true;
		}
		
		private function renderer_mouseDownHandler(event:MouseEvent):void 
		{
			_lastActiveRenderer = event.currentTarget as DisplayObject;
			_lastActiveIndex = testPanel.getIndexForItem(_lastActiveRenderer);
			DragManager.setDragTarget(_lastActiveRenderer);
			_lastActiveRenderer.visible = false;
		}
	}
}