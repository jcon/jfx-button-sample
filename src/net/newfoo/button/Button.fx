/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Jim Connell wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Jim Connell
 * ----------------------------------------------------------------------------
 */
package net.newfoo.button;

import javafx.scene.CustomNode;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.text.Text;

/**
 * Represents a generic button control.  This class will bind to a group
 * that contains the 4 different states a button can display and an
 * active area that can be used for capturing mouse events. Users of
 * the class should pass the group with the 5 elements to
 * the button on construction.
 *
 * NOTES: a more robust button might even allow for construction of a
 * button in an arbitrary way.  The more robust button for instance
 * would allow for the states to be located and placed in designer arbitrary
 * locations.
 *
 * @author jconnell
 */

public class Button {
    /**
     * Represents the 5 element group containing the 4 states of the button
     * and an "active area" for tracking mouse events
     */
    public-init var group : Group on replace {
        normal = group.content[4];
        hovered = group.content[3];
        pressed = group.content[2];
        disabled = group.content[1];
        activeArea = group.content[0];
    }

    public-init var pressed : Node;

    public-init var hovered : Node;

    public-init var normal : Node;

    public-init var disabled : Node;

    public-init var activeArea : Node;

    /** This function will be called whenever the button is clicked.
     * This variable is useful for binding functionality to button clicks
     * outside of the button
     */
    public var action : function ():Void;

    /** 
     * Property to control whether our button is enabled/disabled.  Setting
     * a button to disabled will cause the button to display the disabled
     * state.  The button will also ignore mouse events.
     */
    public var disable = false on replace {
        activeArea.disable = disable;
        if (disable) {
            isPressed = isHovered = false;
            normal.visible = hovered.visible = pressed.visible = false;
        } else {
            normal.visible = hovered.visible = pressed.visible = true;
        }
    }

    var isPressed : Boolean on replace {
        updateUI ();
    }
    var isHovered : Boolean on replace {
        updateUI ();
    }

    init {
        // configure our mouse events on the active area -- the only
        // area we can be gaurenteed to be visible at any given time.
        if (activeArea != null) {
            activeArea.onMouseEntered = function (e) {
                if (not disable) {
                    isHovered = true;
                }
            }
            activeArea.onMouseExited = function (e) {
                if (not disable) {
                    isHovered = false;
                }
            }
            activeArea.onMousePressed = function (e) {
                if (not disable) {
                    isPressed = true;
                }
            }
            activeArea.onMouseReleased = function (e) {
                if (not disable) {
                    isPressed = false;
                    action();
                }
            }
        }
        isPressed = false;
        isHovered = false;
        updateUI ();
    }

    function updateUI () {
        if (pressed != null)
            pressed.visible = isPressed;
        if (hovered != null)
            hovered.visible = not isPressed  and  isHovered;
        if (hovered != null)
            normal.visible = not isPressed  and  not isHovered;
    }
}
