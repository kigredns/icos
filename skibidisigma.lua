local player = game.Players.LocalPlayer

-- Zaktualizowana whitelist w formie zestawu (set)
local whitelist = {
    ["wojtes_bmw"] = true, ["kajaaja8"] = true, ["davikaof2"] = true, ["fortesyt"] = true,
    ["xxxahjmrkim"] = true, ["roma22aaa"] = true, ["freaknotthis"] = true, ["apullahh"] = true,
    ["agamedveloperr"] = true, ["archie_lovesroblox73"] = true, ["ashwingamernov062013"] = true,
    ["xdemon_zuko"] = true, ["jake727why"] = true, ["tuber93333666"] = true, ["omenino_hg"] = true,
    ["joelex16mp"] = true, ["kirarija"] = true, ["mahaz1122"] = true, ["artthecut"] = true,
    ["f_ajgn"] = true, ["thegemeur776"] = true, ["hewinzx"] = true, ["turyhd666"] = true,
    ["criptical_bcc"] = true, ["kfgdhdhdhd"] = true, ["lukas_hack05"] = true, ["water9165"] = true,
    ["zayo_alfa1"] = true, ["xxitalydarck91xx"] = true, ["devopgamer11"] = true, ["andreaxsolara"] = true,
    ["dancgo8ud"] = true, ["ciqstek"] = true, ["guh2405rei"] = true, ["rtrt967"] = true,
    ["madhya78"] = true, ["15dayslater4554"] = true, ["pitler12"] = true, ["hackandres_dreamxd"] = true,
    ["gukzinh3ll"] = true, ["coucou_302"] = true, ["derareaz"] = true, ["v8bit2"] = true,
    ["jams1119"] = true, ["rubinium0"] = true, ["pro_player2895"] = true, ["ggyfic68_764"] = true,
    ["lacipropro"] = true, ["digitosim973"] = true, ["bkak_444"] = true, ["kkwildone"] = true,
    ["superloulou60"] = true, ["1x1xroblox1x"] = true, ["holichyl"] = true, ["saitama112323"] = true,
    ["o2s1u2rr2"] = true, ["samexsamex"] = true, ["rami000010"] = true, ["majestic371"] = true,
    ["zrvll_1"] = true, ["okvgn_dontban"] = true, ["2115hack2115"] = true, ["kimsagaming"] = true,
    ["aaapakdiddj"] = true, ["leoxplosionbenedetty"] = true, ["kiroosofinee"] = true,
    ["ivannchava21"] = true, ["lacipropro0"] = true, ["olidragon210"] = true, ["sreymey2k"] = true,
    ["kevingarcia1112"] = true, ["denstar123456"] = true, ["bro185"] = true, ["00x_alii"] = true,
    ["aaapakdjdid"] = true, ["muhamadarif2013"] = true, ["indonesia_1279"] = true, ["13lil1ian"] = true,
    ["sybau66"] = true, ["bladeballmm22"] = true, ["niskajy12300"] = true, ["matti_remastered"] = true,
    ["caughtulacking14"] = true, ["678910he"] = true, ["winler07"] = true, ["leangip"] = true,
    ["hanumang2021"] = true, ["kittysnowball35"] = true, ["dzifxicyxy"] = true, ["whatisawoman0"] = true,
    ["lilbrostoleyogirl"] = true, ["normalbaconha6"] = true, ["fotpos"] = true, ["susychat_1"] = true,
    ["meydsonlindoyt"] = true, ["candy_oc2023"] = true, ["alien89470"] = true, ["lucasmecher101"] = true,
    ["deltaexecutorlink5"] = true, ["weber84430"] = true, ["antekwoszszczczek"] = true, ["azkahattaa"] = true,
    ["currentaka"] = true, ["nolimitegoyjunior"] = true, ["valtttteri"] = true, ["itthegoodgamer5484"] = true,
    ["imthegoatcr7sui_7"] = true, ["ezbydario"] = true, ["seb_xdb0"] = true, ["x3zlp"] = true,
    ["dory1238bo"] = true, ["lilman073016"] = true, ["mskrnebd"] = true, ["ytplayz376"] = true,
    ["pluhh32"] = true, ["elo_alanowiecz"] = true, ["imjustsusing"] = true, ["reyvings"] = true,
    ["lotofsand"] = true, ["melikp001"] = true, ["asmrshade12345"] = true, ["alucardheroherobar2"] = true,
    ["alexbutonmobile"] = true, ["daxyonyt"] = true, ["yoyo666687"] = true, ["also_nottze1"] = true,
    ["ian2014_m"] = true, ["v3rticalslabs"] = true, ["joey02222016"] = true, ["pun123nool2"] = true,
    ["keahidagod768"] = true, ["caaaa_308"] = true, ["sr_tocino353"] = true, ["jorge_62671"] = true,
    ["d4ry4n"] = true, ["devilkitty_exe"] = true, ["gajkskaksk"] = true, ["krvinja"] = true,
    ["dyspotbj"] = true, ["alexislebo"] = true, ["andri_hack908"] = true, ["animelordddddd"] = true,
    ["kalelyt1233"] = true, ["roboduderkranto_o"] = true, ["bottomlessgluttony"] = true,
    ["toria_1402"] = true, ["vincelawrencefromv"] = true, ["yoyo666687"] = true,
    ["asmrshade12345"] = true, ["rose_love1458"] = true, ["oksanayel"] = true, ["ameerkingx"] = true,
    ["dhutaob"] = true, ["vicki_nice9"] = true, ["rickdarky"] = true, ["kakaz1t"] = true,
    ["syncix9"] = true, ["rayanletueur"] = true, ["noam5902"] = true, ["youki2021k"] = true,
    ["luckyman_39"] = true, ["aladeath1"] = true, ["alhorijrwahabjr"] = true, ["munnaindia"] = true,
    ["aizerion"] = true, ["pulmax14"] = true, ["janek0599"] = true, ["c00lkidd4661"] = true,
    ["rodrigo_br157"] = true, ["9876543210hdud"] = true, ["star52050"] = true,
    ["biely2kkj"] = true, ["2324vip1"] = true, ["vak_3zz"] = true, ["noob_066613"] = true,
    ["maxence28000"] = true, ["littlemen_soprakenny"] = true, ["elpro97838"] = true, ["gogo_wee07"] = true,
    ["hii71020"] = true, ["mylesplaystation"] = true, ["wicia6977"] = true,
    ["headhittaa"] = true, ["ban55562"] = true, ["aaron200158"] = true, ["szym0n456"] = true, ["kwmern"] = true
}

-- Funkcja normalizująca nazwę użytkownika (zmiana na małe litery i usunięcie spacji)
local function normalizeUsername(username)
    return username:lower():gsub("%s+", "")
end

-- Funkcja sprawdzająca, czy użytkownik jest na whiteliście
local function isWhitelisted(username)
    return whitelist[normalizeUsername(username)] or false
end

-- Sprawdzenie użytkownika i reakcja na wynik
if isWhitelisted(player.Name) then
    print("Whitelisted: " .. player.Name)
else
    print(player.Name .. " is not on the whitelist. Kicking...")
    player:Kick("Hello, to use Vip you need to buy a shirt for 65 Robux")
end
