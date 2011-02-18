/**                                                               *                                                               ** Initial haXe port by Brett Johnson, http://now.periscopic.com   ** Project site: code.google.com/p/gtweenhx/                       ** . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . *** MotionBlurPlugin by Grant Skinner. Nov 3, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.motion.plugins;		import com.gskinner.motion.GTween;	import flash.filters.BlurFilter;	import com.gskinner.motion.plugins.IGTweenPlugin;		/**	* Plugin for GTween. Automatically applies a motion blur effect when x & y are tweened. This plugin	* will create a new blur filter on the target, and remove it based on a saved index when the tween ends.	* This can potentially cause problems with other filters that create or remove filters.	* <br/><br/>	* <b>Note:</b> Because it works on the common x,y properties, and has a reasonably high CPU cost,	* this plugin is disabled for all tweens by default (ie. its enabled property is set to false).	* Set <code>pluginData.MotionBlurEnabled</code> to true on the tweens you want to enable it for,	* or set <code>MotionBlurPlugin.enabled</code> to true to enable it by default for all tweens.	* <br/><br/>	* Supports the following <code>pluginData</code> properties:<UL>	* <LI> MotionBlurEnabled: overrides the enabled property for the plugin on a per tween basis.	* <LI> MotionBlurData: Used internally.	* </UL>	**/	class MotionBlurPlugin implements IGTweenPlugin {			// Static interface:		/** Specifies whether this plugin is enabled for all tweens by default. **/		public static var enabled:Bool;//=false;				/** Specifies the strength to use when calculating the blur. A higher value will result in more blurring. **/		public static var strength:Float;// = 0.6;				/** @private **/		private static var instance:MotionBlurPlugin;				static function __init__() {			enabled=false;			strength=0.6;		}				/**		* Installs this plugin for use with all GTween instances.		**/		public static function install():Void {			if (instance!=null) { return; }			#if cpp				throw("nme.filters.BlurFilter does not expose blurX, blurY as of 2.0.1");			#elseif js				throw("jeash.filters.BlurFilter is not implemented");			#else			instance = new MotionBlurPlugin();			GTween.installPlugin(instance,["x","y"]);			#end		}				//Empty constructor		function new(){}			// Public methods:		/** @private **/		public function init(tween:GTween, name:String, value:Float):Float {			return value;		}				/** @private **/		public function tween(tween:GTween, name:String, value:Float, initValue:Float, rangeValue:Float, ratio:Float, end:Bool):Float {			#if !(js||cpp)			if (!((enabled && tween.pluginData.MotionBlurEnabled == null) || tween.pluginData.MotionBlurEnabled)) { return value; }						var data:Dynamic = tween.pluginData.MotionBlurData;			if (data == null) { data = initTarget(tween); }						var f:Array<Dynamic> = tween.target.filters;			var blurF:BlurFilter = cast(f[data.index], BlurFilter);			if (blurF == null) { return value; }			if (end) {				f.splice(data.index,1);				Reflect.deleteField(tween.pluginData,"MotionBlurData");//delete(tween.pluginData.MotionBlurData);			} else {				var blur:Float = Math.abs((tween.ratioOld-ratio)*rangeValue*strength);				if (name == "x") { blurF.blurX = blur; }				else { blurF.blurY = blur; }			}			tween.target.filters = f;			#end			// tell GTween to tween x/y with the default value:			return value;		}			// Private methods:		/** @private **/		private function initTarget(tween:GTween):Dynamic {			var f:Array<Dynamic> = tween.target.filters;			f.push(new BlurFilter(0,0,1));			tween.target.filters = f;			return tween.pluginData.MotionBlurData = {index:f.length-1};		}			}