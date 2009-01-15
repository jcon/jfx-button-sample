/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Jim Connell wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Jim Connell
 * ----------------------------------------------------------------------------
 */

package net.newfoo.button;

import javafx.stage.Stage;
import javafx.scene.Scene;

var buttonUI : ButtonUI = ButtonUI{ }
var button = Button{ group: buttonUI.button };
Stage {
    title: "My Button"
    width: 300
    height: 300
    scene: Scene {
        content: button.group
    }
}