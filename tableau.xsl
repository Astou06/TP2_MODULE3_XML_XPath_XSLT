<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Seuil d'admission : le seul endroit où on écrit 10 -->
    <xsl:param name="seuil" select="10"/>

    <!-- Index des étudiants rangés par classe -->
    <xsl:key name="parClasse" match="etudiant" use="@classe"/>

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

            <!-- Bloc des statistiques -->
            <div class="stats">

            <div class="carte">
                <span class="valeur">
                <xsl:value-of select="count(promotion/etudiant)"/>
                </span>
                <span class="legende">étudiants</span>
            </div>

            <div class="carte">
                <span class="valeur">
                <xsl:value-of select="count(promotion/etudiant[sum(notes/note) div count(notes/note) &gt;= $seuil])"/>
                </span>
                <span class="legende">
                admis (moyenne &gt;= <xsl:value-of select="$seuil"/>)
                </span>
            </div>

            <div class="carte">
                <span class="valeur">
                <xsl:value-of select="format-number(sum(//note) div count(//note), '0.00')"/>
                </span>
                <span class="legende">moyenne en XML</span>
            </div>

            <div class="carte">
                <span class="valeur">
                <xsl:value-of select="count(promotion/etudiant[not(email)])"/>
                </span>
                <span class="legende">emails manquants</span>
            </div>

            </div>

            <!-- Un titre et un tableau par classe -->
            <xsl:for-each select="promotion/etudiant[generate-id() = generate-id(key('parClasse', @classe)[1])]">

            <h2>Classe <xsl:value-of select="@classe"/>
                (<xsl:value-of select="count(key('parClasse', @classe))"/> étudiants)
            </h2>

            <table>
                <thead>
                <tr>
                    <th>Rang</th>
                    <th>Matricule</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Classe</th>
                    <th>Email</th>
                    <th>Moyenne</th>
                    <th>Résultat</th>
                </tr>
                </thead>
                <tbody>
                <xsl:apply-templates select="key('parClasse', @classe)">
                    <xsl:sort select="sum(notes/note) div count(notes/note)"
                            data-type="number" order="descending"/>
                </xsl:apply-templates>
                </tbody>
            </table>

            </xsl:for-each>

        </main>
        </body>
    </html>
    </xsl:template>

    <!-- Modèle 2 : appelé une fois par étudiant, écrit une ligne du tableau -->
    <xsl:template match="etudiant">

    <!-- Moyenne de l'étudiant, calculée une seule fois -->
    <xsl:variable name="moy" select="sum(notes/note) div count(notes/note)"/>

    <tr>
        <!-- L'attribut doit être ajouté avant tout élément enfant (td) -->
        <xsl:if test="position() = 1">
        <xsl:attribute name="class">major</xsl:attribute>
        </xsl:if>

        <td class="rang"><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="@matricule"/></td>
        <td><xsl:value-of select="nom"/></td>
        <td><xsl:value-of select="prenom"/></td>
        <td><xsl:value-of select="@classe"/></td>

        <td>
        <xsl:choose>
            <xsl:when test="not(email)">
            <span class="absent">non renseigné</span>
            </xsl:when>
            <xsl:otherwise>
            <xsl:value-of select="email"/>
            </xsl:otherwise>
        </xsl:choose>
        </td>

        <td class="moyenne">
        <xsl:value-of select="format-number($moy, '0.00')"/>
        </td>

        <td>
        <xsl:choose>
            <xsl:when test="$moy &gt;= $seuil">
            <span class="badge reussite">Admis</span>
            </xsl:when>
            <xsl:otherwise>
            <span class="badge echec">À revoir</span>
            </xsl:otherwise>
        </xsl:choose>
        </td>
    </tr>

    </xsl:template>

</xsl:stylesheet>
