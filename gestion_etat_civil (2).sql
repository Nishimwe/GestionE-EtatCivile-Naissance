-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 13 déc. 2024 à 15:06
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gestion_etat_civil`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `etatCivilParCommune` (IN `id` VARCHAR(255), IN `nom` VARCHAR(50), IN `lastname` VARCHAR(50), IN `cni` VARCHAR(30), IN `idcommune` INT)   SELECT 
        chef.*,
        conj.nom AS conjoint_nom, 
        conj.prenom AS conjoint_prenom,  
        conj.pere AS conjoint_pere,       
        conj.mere AS conjoint_mere,      
        conj.cni AS conjoint_cni, 
        conj.datenaissance AS conjoint_naissance,
        conj.lieunaissance AS conjoint_lieu,
        conj.residence AS conjoint_residence,
        conj.nationalite AS conjoint_nationalite,
        conj.email AS conjoint_mail,
        conj.telephone AS conjoint_phone,
        conj.temoin AS conjoint_temoin,
        conj.temoin2 AS conjoint_temoin2,
        conj.profile AS conjoint_profile
    FROM 
        chefmenage AS chef 
    INNER JOIN 
        conjoint AS conj 
        ON chef.uuid = conj.uuid 
        AND chef.active = conj.active
    WHERE 
        (chef.uuid = id OR id = '') 
        AND ((chef.nom LIKE CONCAT('%', nom, '%') OR nom = '') 
        OR (chef.prenom LIKE CONCAT('%', lastname, '%') OR lastname = '')) 
        AND (chef.cni = cni OR cni = '')
        AND chef.idcommune=idcommune$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllEnfant` (IN `id` INT, IN `nom` VARCHAR(30), IN `pereconnu` VARCHAR(10))   SELECT e.*, c.*, p.* 
FROM enfant e 
INNER JOIN communes c ON e.idcommune = c.idcommune 
INNER JOIN provinces p ON c.idprovince = p.idprovince 
WHERE (e.id = id OR id = 0) 
  AND ((e.nom LIKE CONCAT('%', nom, '%') OR nom = '') 
       OR (e.prenom LIKE CONCAT('%', nom, '%') OR nom= '')) 
  AND (e.pereconnu = pereconnu OR pereconnu = '' OR pereconnu IS NULL)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllEtatCivil` (IN `id` INT, IN `nom` VARCHAR(50), IN `lastname` VARCHAR(50), IN `cni` VARCHAR(30))   SELECT chef.*, p.*,c.*,
            conj.nom AS conjoint_nom, 
            conj.prenom AS conjoint_prenom,  
            conj.pere AS conjoint_pere,       
            conj.mere AS conjoint_mere,      
            conj.cni AS conjoint_cni, 
            conj.datenaissance AS conjoint_naissance,
            conj.lieunaissance AS conjoint_lieu,
            conj.residence AS conjoint_residence,
            conj.nationalite AS conjoint_nationalite,
            conj.email AS conjoint_mail,
            conj.telephone AS conjoint_phone,
            conj.temoin AS conjoint_temoin,
            conj.temoin2 AS conjoint_temoin2,
            conj.profile AS conjoint_profile
            FROM chefmenage AS chef 
            INNER JOIN conjoint AS conj ON                     
            chef.uuid = conj.uuid 
            INNER JOIN communes c ON c.idcommune=chef.idcommune
            INNER JOIN provinces p ON p.idprovince=c.idprovince
            AND chef.active=conj.active
            WHERE(chef.uuid=id OR id=0)
          AND ((chef.nom LIKE CONCAT('%', nom, '%') OR nom= "") 
          OR (chef.prenom LIKE CONCAT('%', lastname, '%') OR lastname= "")) 
          AND (chef.cni=cni OR cni="")$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllEtatCivilForClient` (IN `commune` VARCHAR(30), IN `province` VARCHAR(40))   SELECT 
    chef.nom AS nomchef,
    chef.prenom AS prenomchef,
    chef.pere AS perechef,
    chef.mere AS merechef,
    chef.residence AS residenceChef,
    chef.datemariage AS datemariage,
    chef.nationalite AS nationalitechef,
    chef.profile AS profilechef,
    conj.nom AS conjoint_nom, 
    conj.prenom AS conjoint_prenom,  
    conj.pere AS conjoint_pere,       
    conj.mere AS conjoint_mere,       
    conj.residence AS conjoint_residence,
    conj.nationalite AS conjoint_nationalite,
    conj.profile AS conjoint_profile,
    c.nomcommune AS commune,
    p.nomprovince AS province
    
FROM 
    chefmenage AS chef 
INNER JOIN 
    conjoint AS conj ON                     
    chef.uuid = conj.uuid 
    AND chef.active = conj.active
    AND chef.idcommune = conj.idcommune
INNER JOIN 
    communes AS c ON chef.idcommune = c.idcommune 
INNER JOIN 
    provinces AS p ON c.idprovince = p.idprovince
WHERE 
    (c.nomcommune = commune OR commune = "")
    AND (p.nomprovince = province OR province = "") 
    AND (chef.datemariage>= CURRENT_DATE())$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEnfantParCommune` (IN `id` INT, IN `nom` VARCHAR(50), IN `pereconnu` VARCHAR(10), IN `idcommune` INT)   SELECT e.*, c.*, p.* 
FROM enfant e 
INNER JOIN communes c ON e.idcommune = c.idcommune 
INNER JOIN provinces p ON c.idprovince = p.idprovince 
WHERE (e.id = id OR id = 0) 
  AND ((e.nom LIKE CONCAT('%', nom, '%') OR nom = '') 
       OR (e.prenom LIKE CONCAT('%', nom, '%') OR nom= '')) 
  AND (e.pereconnu = pereconnu OR pereconnu = '' OR pereconnu IS NULL)
   AND (e.idcommune = idcommune)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `chefmenage`
--

CREATE TABLE `chefmenage` (
  `id` int(11) NOT NULL,
  `uuid` text NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `datenaissance` date NOT NULL,
  `lieunaissance` varchar(20) NOT NULL,
  `cni` varchar(20) NOT NULL,
  `residence` varchar(30) NOT NULL,
  `nationalite` varchar(30) NOT NULL,
  `pere` varchar(50) NOT NULL,
  `mere` varchar(50) NOT NULL,
  `datemariage` date DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `telephone` varchar(20) NOT NULL,
  `temoin` varchar(60) NOT NULL,
  `temoin2` varchar(50) NOT NULL,
  `profile` text NOT NULL,
  `idcommune` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `etat` tinyint(1) NOT NULL DEFAULT 1,
  `datecreation` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `chefmenage`
--

INSERT INTO `chefmenage` (`id`, `uuid`, `nom`, `prenom`, `datenaissance`, `lieunaissance`, `cni`, `residence`, `nationalite`, `pere`, `mere`, `datemariage`, `email`, `telephone`, `temoin`, `temoin2`, `profile`, `idcommune`, `active`, `etat`, `datecreation`) VALUES
(1, '27ce1278-0473-4dba-9680-93b3c9140ad6', 'IRAKOZE', 'Eric', '2006-02-02', 'Musigati', '531.025/99886', 'Bubanza', 'Burundaise', 'MINANI Yves', 'MIBURO Silivie', '2024-12-15', 'irakoze@gmail.com', '+257-06-99-33-69', 'NYANDWI Mellance', '', 'hhhhhhh.jfif', 2, 1, 0, '2024-09-28'),
(2, '443a3809-bc74-474a-9639-3d1b5a9a642d', 'IRAKOZE', 'Donacien ', '0000-00-00', 'Songa', '531.045/8995', '', 'Burundaise', 'HABARUGIRA Daniel', 'NDUWARUGIRA Leocadie', '0000-00-00', 'donacien@gmail.com', '+257-66-99-33-69', 'NDIKURIYO Jean', 'KABUTURA Abel', 'homme.jpg', 1, 0, 1, '2024-10-17'),
(3, 'e1db7bd5-4229-4fd1-a726-a88e9295e819', 'NDAYIKEZA', 'Dieudonne ', '2000-03-22', 'Makamba', '531.2255/896', 'Makamba', 'Burundaise', 'NDAYIKEJE Jérémie ', 'MANIRAKIZA Juliette ', '2024-10-10', '', '66993322', 'MANARIYO Jacque ', 'NDAYIKEJE Juvenal', '1729513989725.jfif', 1, 0, 1, '2024-10-21'),
(4, 'afe42137-78bd-4cf4-ae9d-091421f3e426', 'Niyongabo', 'Isaie', '1999-04-16', 'songa', '531.0606/23/12', 'Gitega', 'Burundaise', 'Miburo Louis', 'Gake Consolate', '0000-00-00', '', '', 'Bukuru Enock', 'Niyonkuru Cedric', '1733526819891.jpg', 1, 1, 1, '2024-12-07'),
(5, '444e05c6-f16d-43c0-a9d6-77fba62e39bf', 'Bucumi ', 'jean', '2001-02-09', 'Musogati', '34335/444', 'Rugazi', 'Buundaise', 'Kariyo Jean', 'Nahayo Immacule', '0000-00-00', '', '', 'Kwizera vianney', 'Mutima MIchelle', '1733763923804.jpg', 0, 1, 1, '2024-12-09'),
(6, '38dde6db-7ccc-4879-ae95-68fd21659835', 'Nzitunga', 'Eloge', '2024-11-26', 'songa', '22221/3444', 'Gitega', 'Burundaise', 'Nzitunga Frmin', 'Nduwayo Rosette', '2024-12-28', 'elog@gmail.com', '61111212', 'Irakoze Yves', 'Ndikumazambo Josue', '1733928410179.PNG', 5, 1, 1, '2024-12-11'),
(7, '9e20607e-9860-42cd-8e1d-1dfe16e8dec7', 'Ndikuriyo ', 'Kevin', '1999-07-14', 'Musigati', '543.345', 'BUbanza', 'Burundaise', 'Kayuku Jean', 'Karenzo Marthe', '2025-01-12', 'kevin@gmail.com', '68562564', 'Mutima Longin', 'Masabo Alexis', '1733993959284.PNG', 5, 1, 1, '2024-12-12'),
(8, '722ae2a4-a606-4bfd-9b30-6c2d667582d5', 'MIBURO ', 'Jacque ', '2003-10-16', 'Bubanza', '531.0606/145677', 'Musigati ', 'Burundaise ', 'KARENZO Leoport', 'BUTOYI  Jeanne', '2025-02-08', 'miburo@gmail.com', '78996788', 'BUTOYI Eric', 'IRAMBONA Claude', 'chefmenage1734020070519.jpg', 1, 1, 1, '2024-12-12');

-- --------------------------------------------------------

--
-- Structure de la table `collines`
--

CREATE TABLE `collines` (
  `idcolline` int(11) NOT NULL,
  `nomcolline` varchar(20) NOT NULL,
  `idcommune` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `communes`
--

CREATE TABLE `communes` (
  `idcommune` int(11) NOT NULL,
  `nomcommune` varchar(20) NOT NULL,
  `idprovince` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `communes`
--

INSERT INTO `communes` (`idcommune`, `nomcommune`, `idprovince`) VALUES
(1, 'Bubanza', 1),
(2, 'Gihanga', 1),
(3, 'Musigati', 1),
(4, 'Mpanda', 1),
(5, 'Rugazi', 1),
(6, 'Muha', 2),
(7, 'Mukaza', 2),
(8, 'Ntahangwa', 2),
(10, 'Kabezi', 3),
(11, 'Kanyosha', 3),
(12, 'Mubimbi', 3),
(13, 'Mugongomanga', 3),
(14, 'Mukike', 3),
(15, 'Mutambu', 3),
(16, 'Mutimbuzi', 3),
(17, 'Nyabiraba', 3),
(18, 'Isare', 3),
(19, 'Bururi', 4),
(20, 'Matana', 4),
(21, 'Mugamba', 4),
(22, 'Rutovu', 4),
(23, 'Singa', 4),
(24, 'Vyanda', 4),
(25, 'Cankuzo', 5),
(26, 'Cendajuru', 5),
(27, 'Gisagara', 5),
(28, 'Kigamba', 5),
(29, 'Mishiha', 5);

-- --------------------------------------------------------

--
-- Structure de la table `conjoint`
--

CREATE TABLE `conjoint` (
  `id` int(11) NOT NULL,
  `uuid` text NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `datenaissance` date NOT NULL,
  `lieunaissance` varchar(20) NOT NULL,
  `cni` varchar(20) NOT NULL,
  `residence` varchar(30) NOT NULL,
  `nationalite` varchar(30) NOT NULL,
  `pere` varchar(50) NOT NULL,
  `mere` varchar(50) NOT NULL,
  `datemariage` date DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `telephone` varchar(20) NOT NULL,
  `temoin` varchar(60) NOT NULL,
  `temoin2` varchar(50) NOT NULL,
  `profile` text NOT NULL,
  `idcommune` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  `etat` tinyint(4) NOT NULL DEFAULT 1,
  `datecreation` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `conjoint`
--

INSERT INTO `conjoint` (`id`, `uuid`, `nom`, `prenom`, `datenaissance`, `lieunaissance`, `cni`, `residence`, `nationalite`, `pere`, `mere`, `datemariage`, `email`, `telephone`, `temoin`, `temoin2`, `profile`, `idcommune`, `active`, `etat`, `datecreation`) VALUES
(1, '27ce1278-0473-4dba-9680-93b3c9140ad6', 'IRAKOZE', 'Yvette', '2008-09-12', 'Musigati', '531.256/69988', 'Musigati', 'Burundaise', 'NDUWIMANA Audace', 'NYABENDA Denise', '0000-00-00', 'yvette@gmail.com', '+257-66-99-33-69', 'NDAYIKEZA Diane ', '', 'fille.jpg', 2, 1, 0, '2024-09-28'),
(2, '443a3809-bc74-474a-9639-3d1b5a9a642d', 'IRAKOZE', 'Nadine', '2000-03-09', 'Songa', '531.0606/145', '', 'Burundaise', 'MINANI Thacien', 'MIBURO Jacqueline ', '0000-00-00', '', '', 'IRANGABIYE Clarisse ', 'KANEZA Adnette ', 'ffff.jfif', 1, 0, 1, '2024-10-17'),
(3, 'e1db7bd5-4229-4fd1-a726-a88e9295e819', 'KANKINDI', 'Alice', '0000-00-00', 'Mabanda', '531.25/8899', 'Mabanda', 'Burundaise', 'NTAKIRUTIMANA Silas', 'MUKESHIMANA Nadine ', '2024-10-10', '', '69335588', 'CITEGETSE Jacqueline', 'NDAYIKUNDA Solange', '1729514000735.jfif', 1, 0, 1, '2024-10-21'),
(4, 'afe42137-78bd-4cf4-ae9d-091421f3e426', 'Gakobwa ', 'Marie', '2001-06-11', '', '531.234/12', 'gitega', 'burundaise', 'Bucumie Leonidas', 'Macukiro GOdeberthe', '0000-00-00', '', '', 'Gateka Lydie', 'Manariyo Jacqueline', '1733526819891.jpg', 1, 1, 1, '2024-12-07'),
(5, '444e05c6-f16d-43c0-a9d6-77fba62e39bf', 'Irakoze ', 'Grace', '2003-03-14', 'songa', '22221/3445', 'gitega', 'Burundaise', 'Ndikumana florent', 'gakobwa Joselyne', '0000-00-00', '', '', 'Keza Jeanine', 'Korayo Ines', '1733763923804.jpg', 0, 1, 1, '2024-12-09'),
(6, '38dde6db-7ccc-4879-ae95-68fd21659835', 'Kimana ', 'Estella', '2024-12-13', 'Musigati', '531.234/12', 'gitega', 'Burundaise', 'Butoyi Jean', 'Gakobwa Hollande', '2024-12-28', 'eve@gmail.com', '7111111', 'Ciza Ines', 'Kayo Stael', '1733928410179.PNG', 5, 1, 1, '2024-12-11'),
(7, '9e20607e-9860-42cd-8e1d-1dfe16e8dec7', 'NDAYIKEZA ', 'Grace', '2003-03-20', 'Gitega', '308.355', 'Gitega', 'Burundaise', 'Burikukiye', 'Nahayo', '2025-01-12', 'gra@gmail.com', '65565656', 'Kwizera Matilde', 'Kubwayo Immacle', '1733993959284.PNG', 5, 1, 1, '2024-12-12'),
(8, '722ae2a4-a606-4bfd-9b30-6c2d667582d5', 'NDAYIKEZA ', 'Nadine', '2006-11-24', 'Bubanza', '531.234/1245', 'Musigati', 'Burundaise', 'MINANI Thacien', 'BUTOYI  Jeanine', '2025-02-08', 'ndayikeza@gmail.com', '76899987', 'IRANGABIYE Clarisse ', 'IRAMBONA Claudine', 'conjoint1734020070519.jpg', 1, 1, 1, '2024-12-12');

-- --------------------------------------------------------

--
-- Structure de la table `enfant`
--

CREATE TABLE `enfant` (
  `id` int(11) NOT NULL,
  `uuid` text NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `datenaissance` date NOT NULL,
  `lieunaissance` varchar(40) NOT NULL,
  `pereconnu` varchar(10) NOT NULL,
  `pere` varchar(50) NOT NULL,
  `residencepere` varchar(40) NOT NULL,
  `agepere` varchar(40) NOT NULL,
  `nationalitepere` varchar(40) NOT NULL,
  `professionpere` varchar(40) NOT NULL,
  `mere` varchar(50) NOT NULL,
  `residencemere` varchar(40) NOT NULL,
  `agemere` varchar(40) NOT NULL,
  `nationalitemere` varchar(40) NOT NULL,
  `professionmere` varchar(20) NOT NULL,
  `conjoint` varchar(20) NOT NULL,
  `idcommune` int(11) NOT NULL,
  `datecreation` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `enfant`
--

INSERT INTO `enfant` (`id`, `uuid`, `nom`, `prenom`, `datenaissance`, `lieunaissance`, `pereconnu`, `pere`, `residencepere`, `agepere`, `nationalitepere`, `professionpere`, `mere`, `residencemere`, `agemere`, `nationalitemere`, `professionmere`, `conjoint`, `idcommune`, `datecreation`) VALUES
(1, '4a5a0823-b66d-46e2-bf2c-7e8338aebd25', 'NDAYIRAGIJE ', 'Jean Marie ', '2024-09-10', 'mutambu', 'NON', '', '', '', '', '', 'MINANI Silivie', 'Mutambu', 'vingt-sept', 'Burundaise', 'Cultivateur', 'undefined', 1, '2024-09-25'),
(2, '10c9b757-3bf0-45bd-b861-d8a1da8e0287', 'IRAKOZE', 'ffff', '2024-10-12', 'mutambu', 'NON', '', '', '', '', '', 'MINANI Silivie', 'Mutambu', 'vingth', 'burundaise', 'culti', '', 1, '2024-10-10'),
(3, '4234b925-ab06-4ab0-ba6c-6f0ce99c1c73', 'IRAKOZE', 'ffff', '2024-10-12', 'mutambu', 'NON', '', '', '', '', '', 'MINANI Silivie', 'Mutambu', 'vingth', 'burundaise', 'culti', '', 2, '2024-10-10'),
(4, '822d1cb8-6fa4-41f8-86f2-146d9ff08869', 'IRANKUNDA', 'Yvone', '2024-09-28', 'kabuye', 'OUI', 'MIBURO Eric', 'Kabuye', 'vingt-sept', 'Burundaise', 'Cultivateur', 'BUTOYI  Jeanne', 'Kiriri', 'vingt-un', 'Burundaise', 'Cultivateur', 'OUI', 1, '2024-10-16');

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `expediteur` varchar(50) NOT NULL,
  `email_or_phone` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `idcommune` int(11) NOT NULL,
  `datecreation` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `expediteur`, `email_or_phone`, `message`, `idcommune`, `datecreation`) VALUES
(1, 'NDAYIKEZA Juvenal', '67897788', 'J\'Admire ', 3, '2024-10-22 21:26:59'),
(2, 'IRAKOZE Eric', '67897788', 'J\'Admire ', 2, '2024-10-22 21:29:59'),
(3, 'KABURA Jacque ', 'kabura@gmail.com', 'le cite est accessible ', 1, '2024-10-22 22:16:29'),
(4, 'IRAKOZE Yvette', 'irakoze@gmail.com', 'Félicitation ', 1, '2024-10-22 22:29:37'),
(5, 'IRANKUNDA Alice', '65889933', 'hhhhhhh', 1, '2024-10-23 14:32:02'),
(6, 'IRANKUNDA Alice', '65889933', 'hhhhhhh', 1, '2024-10-23 14:32:15'),
(7, 'nishimwe bertrand', '79528747', 'attention le mariage de irakoze eric et irakpoze yvette doit etre suspendu pour raison d;avoir femme a gitega', 1, '2024-12-04 11:53:01');

-- --------------------------------------------------------

--
-- Structure de la table `provinces`
--

CREATE TABLE `provinces` (
  `idprovince` int(11) NOT NULL,
  `nomprovince` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `provinces`
--

INSERT INTO `provinces` (`idprovince`, `nomprovince`) VALUES
(1, 'Bubanza'),
(2, 'Bujumbura Mairie'),
(3, 'Bujumbura'),
(4, 'Bururi'),
(5, 'Cankuzo'),
(6, 'Cibitoke'),
(7, 'Gitega'),
(8, 'Karuzi'),
(9, 'Kayanza'),
(10, 'Kirundo'),
(11, 'Makamba'),
(12, 'Muramvya'),
(13, 'Muyinga'),
(14, 'Mwaro'),
(15, 'Ngozi '),
(16, 'Rumonge'),
(17, 'Rutana'),
(18, 'Ruyigi');

-- --------------------------------------------------------

--
-- Structure de la table `role`
--

CREATE TABLE `role` (
  `idrole` int(11) NOT NULL,
  `nomrole` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `role`
--

INSERT INTO `role` (`idrole`, `nomrole`) VALUES
(1, 'SupperAdmin'),
(2, 'Admin Communal '),
(3, 'Secrétaire communal  ');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id` int(11) NOT NULL,
  `uuid` text NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telephone` varchar(20) NOT NULL,
  `role` int(11) NOT NULL,
  `idcommune` int(11) NOT NULL,
  `nomutilisateur` varchar(50) NOT NULL,
  `motdepasse` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `datecreation` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `uuid`, `nom`, `prenom`, `email`, `telephone`, `role`, `idcommune`, `nomutilisateur`, `motdepasse`, `active`, `datecreation`) VALUES
(1, '777177bf-f64d-4f90-89fb-340f8b2dc1ab', 'NDAYIRAGIJE ', 'JMV', 'ndayiragijejmv1@gmail.com', '79867809', 2, 1, 'JMV', '$2a$10$jD4i6HEoPxznDQZGughODuDMBy7LHjKMIpbSjrWOtMY5iWmhadXW6', 1, '2024-10-16'),
(2, 'a0e6d41c-7107-49c0-ae6d-2d312d9619ad', 'NDAYIKEZA ', 'Juvénal', 'juvenal@gmail.com', '69553322', 1, 6, 'Juvenal', '$2a$10$Yg1lxougCYgyyI/W9USCA.6NghX36DhCUGbTuoxtudunne.XxmlR6', 1, '2024-10-24'),
(3, '82c29180-c77d-4342-a7f7-d1a7967331eb', 'KARENZO ', 'Eric', 'karenzo@gmail.com', '', 2, 3, 'KARENZO', '$2a$10$itrEjK1KK0MT8z0TopDtfOPdLn9sscSJb.K5jonrzofyNtqy5Jas.', 1, '2024-10-24'),
(11, 'e537ca05-cd51-408e-b856-e546bdafe9a9', 'IRAKOZE ', 'Aline', 'aline@gmail.com', '65889932', 3, 1, 'Aline', '$2a$10$Fq1HBbCNlUetEL1dtD3tVOvFZ7fSGwNx.MgbOg4E5lVcTsA7XPkp6', 1, '2024-10-24'),
(12, '5ea9a5f2-36f7-4669-9e33-b62c9f096f46', 'Nishimwe', 'Bertrand', 'berthrandnishimwe@gmail.com', '61130138', 2, 5, 'Bertrand', '$2a$10$QhXrqIz0qRzMmvK.ord2EuPZ2QqjBPo3RGCFNY041jaOzY.baSB8q', 1, '2024-12-09');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `chefmenage`
--
ALTER TABLE `chefmenage`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `communes`
--
ALTER TABLE `communes`
  ADD PRIMARY KEY (`idcommune`);

--
-- Index pour la table `conjoint`
--
ALTER TABLE `conjoint`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `enfant`
--
ALTER TABLE `enfant`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `provinces`
--
ALTER TABLE `provinces`
  ADD PRIMARY KEY (`idprovince`);

--
-- Index pour la table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`idrole`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `chefmenage`
--
ALTER TABLE `chefmenage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `communes`
--
ALTER TABLE `communes`
  MODIFY `idcommune` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT pour la table `conjoint`
--
ALTER TABLE `conjoint`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `enfant`
--
ALTER TABLE `enfant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `provinces`
--
ALTER TABLE `provinces`
  MODIFY `idprovince` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `role`
--
ALTER TABLE `role`
  MODIFY `idrole` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
