<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Modèle 1 : la racine, qui écrit la page complète -->
    <xsl:template match="/">
    <html>
        <head>
        <meta charset="UTF-8"/>
        <title><xsl:value-of select="promotion/@filiere"/></title>
        <link rel="stylesheet" href="style.css"/>
        </head>
        <body>
            <header>
                <h1>Promotion <xsl:value-of select="promotion/@filiere"/></h1>
                <p>Année <xsl:value-of select="promotion/@annee"/></p>
            </header>
            <main>
                <table>
                    <thead>
                        <tr>
                            <th>Matricule</th>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Classe</th>
                            <th>Email</th>
                            <th>Moyenne</th>
                        </tr>
                    </thead>
                    <tbody>
                    <xsl:apply-templates select="promotion/etudiant"/>
                    </tbody>
                </table>
            </main>
        </body>
    </html>
    </xsl:template>

    <!-- Modèle 2 : appelé une fois par étudiant, écrit une ligne du tableau -->
    <xsl:template match="etudiant">
        <tr>
            <td><xsl:value-of select="@matricule"/></td>
            <td><xsl:value-of select="nom"/></td>
            <td><xsl:value-of select="prenom"/></td>
            <td><xsl:value-of select="@classe"/></td>
            <td><xsl:value-of select="email"/></td>
            <td class="moyenne">
            <xsl:value-of select="format-number(sum(notes/note) div count(notes/note), '0.00')"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>