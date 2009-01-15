<?xml version="1.0" ?>
<!--
/**
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Jim Connell wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Jim Connell
 */
 -->
<!--
XSL template for converting portions of InkScape SVG files that
break svg2fx conversions.  The svg2fx converter tries to convert any gradients
with transform or matrix transforms directly into JavaFX.  Unfortunately,
JavaFX gradients do not support transforms, so resulting FXD files do not look
as they do in InkScape.

To work around the issue, this XSL file will take the input SVG and
apply any transform or matrix transforms for gradients directly into
the gradient's coordinate system.  This allows JavaFX to properly render
the gradients as they appear in InkScape.
-->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">

    <!-- start the translation with an identity transform.  If there is no
    matching template defined below for a given element/attribute, this
    stylesheet will pass the given element/attribute through unchanged. -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- Override handling for linearGradients that have transforms and
    removes the gradient transform from the output.

    Incorporate any coordinate transforms of linear gradients directly
    into the start (x,y) and end (x,y) coordinates -->
    <xsl:template match="/svg:svg/svg:defs/svg:linearGradient[starts-with(@gradientTransform, 'translate')]">
        <!-- pull out the x translation value -->
        <xsl:variable name="xval">
            <xsl:value-of select="substring-after(substring-before(@gradientTransform, ','), 'translate(')"/>
        </xsl:variable>
        <!-- pull out the y translation value -->
        <xsl:variable name="yval">
            <xsl:value-of select="substring-after(substring-before(@gradientTransform, ')'), ',')"/>
        </xsl:variable>
        <linearGradient
           inkscape:collect="{@inkscape:collect}"
           xlink:href="{@xlink:href}"
           id="{@id}"
           gradientUnits="{@gradientUnits}"
           x1="{@x1 + $xval}"
           y1="{@y1 + $yval}"
           x2="{@x2 + $xval}"
           y2="{@y2 + $yval}" />
    </xsl:template>

    <!-- Override handling for linearGradients that have affine transforms
      and removes the gradientTransform from the output.

    Applies the 2D affine transformation matrix directly to the source coordinates
    using the defined matrix in the form of matrix( a b c d e f ) to:

    [ a c e ]   [ x ]   [ a*x + c*y + e ]   [ x' ]
    | b d f | x | y | = | b*x + d*y + f | = | y' |
    [ 0 0 1 ]   [ 1 ]   [        1      ] = [ 1  ]
    -->
    <xsl:template match="/svg:svg/svg:defs/svg:linearGradient[starts-with(@gradientTransform, 'matrix')]">
        <xsl:variable name="coords">
            <xsl:value-of select="substring-after(substring-before(@gradientTransform, ')'), 'matrix(')"/>
        </xsl:variable>
        <xsl:variable name="m00val">
            <xsl:value-of select="substring-before($coords, ',')"/>
        </xsl:variable>
        <xsl:variable name="m10val">
            <xsl:value-of select="substring-before(substring-after($coords, ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m01val">
            <xsl:value-of select="substring-before(substring-after(substring-after($coords, ','), ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m11val">
            <xsl:value-of select="substring-before(substring-after(substring-after(substring-after($coords, ','), ','), ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m02val">
            <xsl:value-of select="substring-before(substring-after(substring-after(substring-after(substring-after($coords, ','), ','), ','), ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m12val">
            <xsl:value-of select="substring-after(substring-after(substring-after(substring-after(substring-after($coords, ','), ','), ','), ','), ',')"/>
        </xsl:variable>

        <linearGradient
           inkscape:collect="{@inkscape:collect}"
           xlink:href="{@xlink:href}"
           id="{@id}"
           gradientUnits="{@gradientUnits}"
           x1="{$m00val * @x1 + $m01val * @y1 + $m02val}"
           y1="{$m10val * @x1 + $m11val * @y1 + $m12val}"
           x2="{$m00val * @x2 + $m01val * @y2 + $m02val}"
           y2="{$m10val * @x2 + $m11val * @y2 + $m12val}" />
    </xsl:template>

    <!-- Incorporate the transform matrix directly into center & focus points
         of the radial gradient and removes the gradientTransform from the output.

    Applies the 2D affine transformation matrix directly to the source coordinates
    using the defined matrix in the form of matrix( a b c d e f ) to:

    [ a c e ]   [ x ]   [ a*x + c*y + e ]   [ x' ]
    | b d f | x | y | = | b*x + d*y + f | = | y' |
    [ 0 0 1 ]   [ 1 ]   [        1      ] = [ 1  ]
    -->
    <xsl:template match="/svg:svg/svg:defs/svg:radialGradient[starts-with(@gradientTransform, 'matrix')]">
        <xsl:variable name="coords">
            <xsl:value-of select="substring-after(substring-before(@gradientTransform, ')'), 'matrix(')"/>
        </xsl:variable>
        <xsl:variable name="m00val">
            <xsl:value-of select="substring-before($coords, ',')"/>
        </xsl:variable>
        <xsl:variable name="m10val">
            <xsl:value-of select="substring-before(substring-after($coords, ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m01val">
            <xsl:value-of select="substring-before(substring-after(substring-after($coords, ','), ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m11val">
            <xsl:value-of select="substring-before(substring-after(substring-after(substring-after($coords, ','), ','), ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m02val">
            <xsl:value-of select="substring-before(substring-after(substring-after(substring-after(substring-after($coords, ','), ','), ','), ','), ',')"/>
        </xsl:variable>
        <xsl:variable name="m12val">
            <xsl:value-of select="substring-after(substring-after(substring-after(substring-after(substring-after($coords, ','), ','), ','), ','), ',')"/>
        </xsl:variable>
        <!--xsl:value-of select="$m00val"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$m01val"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$m02val"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$m10val"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$m11val"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$m12val"/-->

        <radialGradient
           inkscape:collect="{@inkscape:collect}"
           xlink:href="{@xlink:href}"
           id="{@id}"
           gradientUnits="{@gradientUnits}"
           cx="{$m00val * @cx + $m01val * @cy + $m02val}"
           cy="{$m10val * @cx + $m11val * @cy + $m12val}"
           fx="{$m00val * @fx + $m01val * @fy + $m02val}"
           fy="{$m10val * @fx + $m11val * @fy + $m12val}"
            r="{@r}" />
    </xsl:template>

</xsl:stylesheet>
