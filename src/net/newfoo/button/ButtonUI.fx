/*
 * Generated by JavaFX Production Suite NetBeans plugin.
 * ButtonUI.fx
 *
 * Created on Fri Jan 09 11:48:16 EST 2009
 */
package net.newfoo.button;

import java.lang.Object;
import java.lang.System;
import java.lang.RuntimeException;
import javafx.scene.Node;
import javafx.fxd.UiStub;
import javafx.scene.Group;

public class ButtonUI extends UiStub {
	
	override public var url = "{__DIR__}button.fxz";
	// Changing button to be a Group instead of node makes it easier
    // to work with in our Button class.
	public var button: Group;
	
	override protected function update() {
		lastNodeId = null;
		 try {
			button=getGroup("button");
		} catch( e:java.lang.Exception) {
			System.err.println("Update of the  attribute '{lastNodeId}' failed with: {e}");
			throw e;
		}
	}
}

