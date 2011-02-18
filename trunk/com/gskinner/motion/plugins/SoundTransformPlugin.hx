/**                                                               *                                                               ** Initial haXe port by Brett Johnson, http://now.periscopic.com   ** Project site: code.google.com/p/gtweenhx/                       ** . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . *** SoundTransformPlugin by Grant Skinner and Sebastian DeRossi. Nov 3, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.motion.plugins;		import com.gskinner.motion.GTween;	import com.gskinner.motion.plugins.IGTweenPlugin;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;		/**	* Plugin for GTween. Tweens the volume, pan, leftToLeft, leftToRight, rightToLeft, and rightToRight	* properties of the target's soundTransform object.	* <br/><br/>	* Supports the following <code>pluginData</code> properties:<UL>	* <LI> SoundTransformEnabled: overrides the enabled property for the plugin on a per tween basis.	* </UL>	**/	class SoundTransformPlugin implements IGTweenPlugin {			// Static interface:		/** Specifies whether this plugin is enabled for all tweens by default. **/		public static var enabled:Bool;//=true;				/** @private **/		private static var instance:SoundTransformPlugin;		/** @private **/		private static var tweenProperties:Array<String>;// = ["leftToLeft", "leftToRight", "pan", "rightToLeft", "rightToRight", "volume"];				static function __init__() {			enabled = true;			tweenProperties = ["leftToLeft", "leftToRight", "pan", "rightToLeft", "rightToRight", "volume"];		}				/**		* Installs this plugin for use with all GTween instances.		**/		public static function install():Void {			if (instance!=null) { return; }			instance = new SoundTransformPlugin();			GTween.installPlugin(instance, tweenProperties, true);		}				//Empty constructor		function new(){}			// Public methods:		/** @private **/		public function init(tween:GTween, name:String, value:Float):Float {			if (!((enabled && tween.pluginData.SoundTransformEnabled == null) || tween.pluginData.SoundTransformEnabled)) { return value; }						return Reflect.field(tween.target.soundTransform,name);//tween.target.soundTransform[name];		}				/** @private **/		public function tween(tween:GTween, name:String, value:Float, initValue:Float, rangeValue:Float, ratio:Float, end:Bool):Float {			if (!((enabled && tween.pluginData.SoundTransformEnabled == null) || tween.pluginData.SoundTransformEnabled)) { return value; }						var soundTransform:SoundTransform = tween.target.soundTransform;						Reflect.setField(soundTransform,name,value);//soundTransform[name] =  value;			tween.target.soundTransform = soundTransform;						// tell GTween not to use the default assignment behaviour:			return Math.NaN;		}	}