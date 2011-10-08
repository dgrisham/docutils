<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.1"
    >
    <!-- $Id: error.xsl 7131 2011-09-26 19:27:15Z paultremblay $ -->

    <xsl:template name="test-params">

        <xsl:if test= "$option-list-format != 'list'  and $option-list-format != 'definition'">
            <xsl:variable name="msg">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$option-list-format"/>
                <xsl:text>" not a valid value for param "option-list-format"&#xA;</xsl:text>
                <xsl:text>Valid values are 'list', and 'definition'&#xA;</xsl:text>
            </xsl:variable>
            <xsl:call-template name="quit-message">
                <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test ="$number-verse != '' and string($number-verse + 1 ) = 'NaN'">
            <xsl:variable name="msg">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$number-verse"/>
                <xsl:text>" not a valid value for param "number-verse"&#xA;</xsl:text>
                <xsl:text>Please use a number&#xA;</xsl:text>
            </xsl:variable>
            <xsl:call-template name="quit-message">
                <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test= "$table-title-placement != 'bottom'  and $table-title-placement != 'top'">
            <xsl:variable name="msg">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$table-title-placement"/>
                <xsl:text>" not a valid value for param "table-title-placement"&#xA;</xsl:text>
                <xsl:text>Valid values are 'top', and 'bottom'&#xA;</xsl:text>
            </xsl:variable>
            <xsl:call-template name="quit-message">
                <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test= "$internal-link-type != 'link'  and $internal-link-type != 'page'
                and $internal-link-type != 'page-link'">
            <xsl:variable name="msg">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$internal-link-type"/>
                <xsl:text>" not a valid value for param "internal-link-type"&#xA;</xsl:text>
                <xsl:text>Valid values are 'link', and 'page', and 'page-link'&#xA;</xsl:text>
            </xsl:variable>
            <xsl:call-template name="quit-message">
                <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>


    <xsl:template name="trace-ancestors">
        <xsl:param name="children"/>
        <xsl:choose>
            <xsl:when test="parent::*">
                <xsl:for-each select="parent::*">
                    <xsl:call-template name="trace-ancestors">
                        <xsl:with-param name="children">
                            <xsl:value-of select="name(.)"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="$children"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$children"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="trace-siblings">
        <xsl:param name="previous-siblings"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::*">
                <xsl:for-each select="preceding-sibling::*[1]">
                    <xsl:call-template name="trace-siblings">
                        <xsl:with-param name="previous-siblings">
                            <xsl:value-of select="name(.)"/>
                            <xsl:text>=></xsl:text>
                            <xsl:value-of select="$previous-siblings"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>siblings: </xsl:text>
                <xsl:value-of select="$previous-siblings"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="trace">
        <xsl:variable name="ancestors">
            <xsl:call-template name="trace-ancestors">
                <xsl:with-param name="children" select="name(.)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="siblings">
            <xsl:call-template name="trace-siblings"/>
        </xsl:variable>
        <xsl:value-of select="$ancestors"/>
        <xsl:text>[</xsl:text>
        <xsl:for-each select="@*">
            <xsl:value-of select="name(.)"/>
            <xsl:text>="</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>" </xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="$siblings"/>
    </xsl:template>


    <xsl:template match="*">
        <xsl:variable name="trace">
            <xsl:call-template name="trace"/>
        </xsl:variable>
        <xsl:message>
            <xsl:text>no match for </xsl:text>
            <xsl:value-of select="$trace"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$strict='True'">
                <xsl:message terminate="yes">
                    <xsl:text>Processing XSLT Stylesheets now quiting</xsl:text>
                </xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>Not processing text in this element.</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="system_message[@type='ERROR']">
        <xsl:message>
            <xsl:text>Error when converting to XML:&#xA;</xsl:text>
            <xsl:value-of select="."/>
        </xsl:message>
        <xsl:if test="$strict='True'">
            <xsl:call-template name="quit-message"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="system_message[@type='ERROR']/paragraph| system_message[@type='ERROR']/literal_block" priority="2"/>

    <xsl:template name="quit-message">
        <xsl:param name="msg"/>
        <xsl:message terminate="yes">
            <xsl:value-of select="$msg"/>
            <xsl:text>Processing stylesheets now quitting.</xsl:text>
        </xsl:message>
    </xsl:template>

    <xsl:template name="error-message">
        <xsl:param name="text"/>
        <xsl:message>
            <xsl:value-of select="$text"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$strict='True'">
                <xsl:call-template name="quit-message"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>Not processing text for this element.</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    
</xsl:stylesheet>