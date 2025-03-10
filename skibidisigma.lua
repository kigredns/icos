local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNamecall = mt.__namecall

setreadonly(mt, false)

-- Funkcja, która wykrywa, czy ktoś próbuje manipulować metatabelą
local function detectTampering()
    if not table.find(getconnections(game.Players.LocalPlayer.AncestryChanged), function(v)
        return v.Function and islclosure(v.Function) and not isexecutorclosure(v.Function)
    end) then
        warn("⚠️ Wykryto próbę manipulacji metatabelą!")
        game.Players.LocalPlayer:Kick("🚨 Nieautoryzowana modyfikacja wykryta.")
    end
end

-- Blokowanie wywołania Kick()
mt.__index = function(self, key)
    if key == "Kick" then
        warn("🚨 Próba wyrzucenia gracza została zablokowana!")
        return function() end  -- Uniemożliwienie wykonania Kick()
    end
    return oldIndex(self, key)
end

mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then
        warn("🚨 Próba wyrzucenia gracza została zablokowana!")
        return function() end
    end
    return oldNamecall(self, ...)
end

setreadonly(mt, true)

-- Wykrywanie manipulacji co kilka sekund
game:GetService("RunService").Stepped:Connect(detectTampering)

print("✅ Anti-Kick aktywne.")

local player = game.Players.LocalPlayer
-- Zaktualizowana whitelist z dodatkowymi nickami
local whitelist = {
"Wojtes_BMW", "KajaAja8", "Davikaof2", "FORTESYT", "Xxxahjmrkim", "roma22aaa", "freaknotthis",
    "apullahh", "AGameDeveloperr", "ARCHIE_LOVESROBLOX73", "ashwingamernov062013", "xdemon_zuko", "JAKE727why",
    "Tuber93333666", "Omenino_HG", "JOELEX16MP", "kirarija", "Mahaz1122", "ArtTheCut", "F_Ajgn", "thegemeur776",
    "HeWinzx", "turyhd666", "CRIPTICAL_BCC", "kfgdhdhdhd", "lukas_hack05", "water9165", "Zayo_alfa1", "Xxitalydarck91xX",
    "DEVOPGAMER11", "AndreaxSolara", "Dancgo8ud", "ciqstek", "guh2405rei", "rtrt967", "Madhya78", "15dayslater4554",
    "Pitler12", "HackAndres_dreamXD", "gukzinh3ll", "coucou_302", "derareaz", "V8BIT2", "jams1119",
    "Rubinium0", "Pro_player2895", "ggyfic68_764", "lacipropro", "DigitoSiM973", "BKAK_444", "kkwildone", "SuperLoulou60",
    "1x1xroblox1x", "holichyl", "saitama112323", "o2s1u2rr2", "samexsamex", "rami000010", "Majestic371",
    "Zrvll_1", "okvgn_DontBan", "2115Hack2115", "KimsaGaming", "aaapakdiddj", "leoxplosionbenedetty",
    "KirooSoFinee", "IvannChava21", "lacipropro0", "olidragon210", "sreymey2k", "kevingarcia1112",
    "denstar123456", "bro185", "00x_Alii", "aaapakdjdid", "muhamadarif2013", "indonesia_1279", "13lil1ian", "sybau66",
    "bladeballmm22", "NISKAJY12300", "Matti_remastered", "caughtulacking14", "678910he", "winler07",
    "Leangip", "Hanumang2021", "kittysnowball35", "dzifxicyxy", "Whatisawoman0", "Lilbrostoleyogirl",
    "Normalbaconha6", "fotpos", "susychat_1", "MEYDSONLINDOyt", "candy_oc2023", "alien89470", "LucaSmecher101",
    "Deltaexecutorlink5", "Weber84430", "AntekWoszszczczek", "azkahattaa", "CURRENTAKA",
    "nolimitegoyjunior", "Valtttteri", "ItTheGoodGamer5484", "Imthegoatcr7sui_7", "ezbydario",
    "seb_xdb0", "x3zlp", "Dory1238bo", "lilman073016", "mskrnebd", "YTplayz376", "pluhh32",
    "ELO_ALANOWIECZ", "imjustsusing", "REYVINGS", "LotOfSand", "MelikP001", "Asmrshade12345", "alucardheroherobar2",
    "alexbutonmobile", "DaXyOnYT", "yoyo666687", "coucou_302", "Also_NotTze1", "ian2014_m", "V3rticalSlabs",
    "joey02222016", "Pun123nool2", "keahidagod768", "caaaa_308", "sr_tocino353", "jorge_62671",
    "D4ry4n", "devilkitty_exe", "gajkskaksk", "krvinja", "DyspoTbj", "alexislebo", "Andri_Hack908", "ANIMELORDDDDDD",
    "kalelyt1233", "RoboDudeRkranto_o", "BottomlessGluttony", "toria_1402", "vincelawrencefromv", "Yoyo666687",
    "AsmrShade12345", "Rose_love1458", "oksanayel", "AmeerKiNGx", "dhutaob", "vicki_nice9", "RickDarKy", "kakaz1t",
    "kakazit01naoe02", "Syncix9", "RAYANLETUEUR", "vicki_nice9", "pamilargabriel", "noam5902", "youki2021k",
    "luckyMan_39", "AvaDeath1", "ALHORIJRWAHABjr", "Munnaindia", "Aizerion",
    "PULMAX14", "janek0599", "c00lkidd4661", "Rodrigo_BR157", "9876543210hdud", "star52050", "biely2kkj",
    "2324VIP1", "VAK_3ZZ", "noob_066613", "maxence28000", "littleMEN_sopraKENNY", "elpro97838", "gogo_wee07",
    "hii71020", "MylesPlayStation", "SuperLoulou60", "Kwmern", "Erick_gamer710", "furtzge",
    "Jqjshzhaj", "aomgwwe113", "wazawazaaa7", "PinkSunSmoke", "x1GORxRAFAELx", "PainThatAlters1",
    "PainThatAlters1", "timbavk_d", "kyoslegacy", "Perroalt98", "Ali352400", "Dj_Sizle", "tribu3zi", "Aizerion",
    "0524Marty", "Elgato0158", "Rayane187332", "lamatonwm", "ZXArturoZX123", "freemikey001", "XxJuanxdxXMTM",
    "Nestorgolybev201", "Berlinerali", "mamadmmad997", "ggandria11", "6kxlisupre", "daxf125",  
"AngelosMod", "ophub000", "thiagonoobbr1", "yAZiUU6071", "Yourweird693", "portuga_c4",  
"gcfrfhdjx2account", "ytr_Jaozin", "drfantasy91", "JuhSFDAH", "Angelofrancisco7", "kitti200300",  
"mahfooz45", "ILoveYou_Alana2", "IloveyouTanq", "FarmerManatee", "DorukAliCelik90", "Fable_Cable",  
"GOON1380", "Ingoul23", "Xanesiy", "Zrk974ii", "thegenier", "Beicon_daquebrada",  
"lehadro_greek15", "ghjghjkfju", "yaboiaction9012", "ta1luar", "dreckpro143", "furtzge",
"Araxis2223", "WhosTrubs", "iiiiiiiiiignas", "itzbaba2", "GLITCHEDSMG44", "forma266", "3omda4reall",
"jerfie22", "spidermanboy11900", "gamersroblox5D", "AgentR6Retro", "yamir19385", "Oscarmanguia",
"gagalol2", "Berlinerali", "Ban55562", "only_Acqua", "TNT_COOKIE35", "Real_Bloodhoodlife", "jolataue3", "Gady1203_2",
"ajfhlka538", "Bro_567452", "tanqrrrrfannnnn1", "Imwibukun", "Krutoichel769", "XxBarackGamingzLOL", "Voner956", "createchgamimg",
"aqwariy", "megaeddie759", "KADZUTORAN1", "Hyexgamer3550", "Roman304010", "noobyguy_1009", "Gamer222boom", "xALOESx21", "Emrelol43", "AceK1nd",
"victor134lko", "dana_Uwy", "luckmioginho", "hdugpfsugs6r", "Gady1203_2", "sweet_tarts738", "edduard647", "risottoJr", "Hanaw1123", "Noetarbler",
"LorenzoSantos138", "raito2574", "y2kpHoOx09p", "5zym0n456", "JakeIsPail", "Rownokboss",
"KJ_911404",  "Pro_241656512", "miguel_pvp441", "SZYMONKONIECZN", "kyleakdarl", "JakeIsPail", "RobKLPC", "todikorik", "Morda_Off",
"mariomaro9089098", "GUYIDBIN", "Aaron200158", "headhittaa", "Monkey_4you2", "luthfi123456l", "JONATHAN803702", "megaeddie759",
"nivar91", "gt3c1", "killerferfre1", "SoyAitorOK", "M0rxun", "AstraOutLight", "vshfsadasofpdahsjufd", "Yarik_100tv",
"NiKoLaI_PM", "Marcel161114", "hawi1661", "XenophiIl", "simipimirajh1", "dipta_indonesia", "WRUNISHKAORIG",
"skibididopdopeses213", "CocoSlapBattles", "JagPro308", "killerferfre1", "WonoBeLike", "Akmal_bilek5", "Jean_Elias1", "WolfPaq_OFC00",
"Cheesekubpom2015", "Gumball_20090", "raroiga", "t_xaas", "ben_samet56", "u_angel948", "gfdcsur", "PolymorphicLen", "jav46917",
"Kingbigz21spam", "bartinio112", "TUBers930return", "xSxYxSx", "linda_rania", "Koroche84",
"087scp_b", "CristBoxXd2", "fahad1234oeo", "imposteurbleu123", "Jean_Elias1", "hawi1661",
"Anonymouse_0862", "yt2222322", "emoli_kaya", "howie100100", "Pessoa_Semconta", "aura22087",
"UnBearable2013", "kalwatochuj", "PIROK_XEREKAdaSUAMAE", "Lena28767", "Vitor360re", "ssggssgg04",
"CristBoxXd2", "Hejasupa", "beneu090", "William_50157", "RX_BoMBa", "RONoblox_9", "krystianpross", "Sasha84444", "hoaithuongvntr",
"trickyymn", "catcheur2014", "steven352531", "Zaphone_TH", "32PN", "danilobiloo", "Ahmet_7710", "Noobalp66",
"vanoooajaa", "Jhonpark11", "cheese1234567890151", "squ1zy69", "Arbaletikk", "jojoperaa", "jaidennnnnn70",
"Charlesapro77", "PvP_202474", "goodcymon1099", "beneu090", "William_50157", "Ladydeathrains", "CocoSlapBattles", "OceanD3", "k10alshehhi"
}
-- Funkcja normalizująca nazwę użytkownika (np. do małych liter)
local function normalizeUsername(username)
    return username:lower():gsub("%s+", "")  -- Zmienia na małe litery i usuwa spacje
end
-- Funkcja sprawdzająca, czy użytkownik jest na whiteliście
local function isWhitelisted(username)
    local normalizedName = normalizeUsername(username)
    for _, whitelistedName in ipairs(whitelist) do
        if normalizeUsername(whitelistedName) == normalizedName then
            return true
        end
    end
    return false
end
-- Sprawdzenie i reakcja na wynik
if isWhitelisted(player.Name) then
    print("Whitelisted: " .. player.Name)
else
    -- Powiadomienie i wyrzucenie użytkownika
    print(player.Name .. " is not on the whitelist. Kicking...")
    player:Kick("You are not on the whitelist. Please contact support for assistance.")
end
