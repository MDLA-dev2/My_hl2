# Справочник по VGUI и рендерингу интерфейсов Garry's Mod

Официальные источники:
- Главная документация: [https://wiki.facepunch.com/gmod/](https://wiki.facepunch.com/gmod/)
- Библиотека VGUI: [https://wiki.facepunch.com/gmod/vgui](https://wiki.facepunch.com/gmod/vgui)
- Библиотека Surface: [https://wiki.facepunch.com/gmod/surface](https://wiki.facepunch.com/gmod/surface)
- Встроенные Silkicons: [https://wiki.facepunch.com/gmod/Silkicons](https://wiki.facepunch.com/gmod/Silkicons)

---

## 1. Архитектура VGUI и реалмы

* **Реалм:** Все операции с VGUI, панелями (`vgui.*`, `PANEL:*`), шрифтами (`surface.CreateFont`) и отрисовкой (`surface.*`, `draw.*`) выполняются **строго на клиенте (`CLIENT`)**.
* **События жизненного цикла панели:**
  - `PANEL:Init()` — вызывается при создании (`vgui.Create`). Настройка дочерних элементов, начальных размеров.
  - `PANEL:PerformLayout(w, h)` — перерасчет позиций и размеров при изменении размеров родителя.
  - `PANEL:Paint(w, h)` — отрисовка панели каждый кадр.
  - `PANEL:PaintOver(w, h)` — отрисовка поверх дочерних элементов.
  - `PANEL:Think()` — логика панели каждый клиентский тик.
  - `PANEL:OnRemove()` — освобождение ресурсов, таймеров.

---

## 2. Ключевые функции `surface` и `draw`

### `surface` (Низкоуровневая быстрая отрисовка)
* `surface.SetDrawColor(r, g, b, a)` или `surface.SetDrawColor(color)` — установка цвета для последующих примитивов.
* `surface.DrawRect(x, y, w, h)` — закрашенный прямоугольник.
* `surface.DrawOutlinedRect(x, y, w, h, thickness)` — контур прямоугольника.
* `surface.SetMaterial(mat)` — связывание материала для отрисовки текстур.
* `surface.DrawTexturedRect(x, y, w, h)` — отрисовка текстурированного прямоугольника.
* `surface.DrawTexturedRectRotated(x, y, w, h, rotation)` — вращаемая текстура.
* `surface.DrawLine(x1, y1, x2, y2)` — линия.

### `draw` (Высокоуровневые утилиты поверх `surface`)
* `draw.RoundedBox(cornerRadius, x, y, w, h, color)` — прямоугольник со скругленными углами.
* `draw.RoundedBoxEx(cornerRadius, x, y, w, h, color, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight)` — выборочное скругление углов.
* `draw.SimpleText(text, font, x, y, color, xAlign, yAlign)` — отрисовка строки с выравниванием (`TEXT_ALIGN_LEFT`, `TEXT_ALIGN_CENTER`, `TEXT_ALIGN_RIGHT`).

---

## 3. Кеширование материалов и шрифтов (Критично для FPS)

> [!CAUTION]
> **Никогда не вызывайте `Material()` или `surface.CreateFont()` внутри функций `Paint`, `DrawHUD` или `Think`!**
> Вызов `Material("...")` каждый кадр приводит к дисковым и строковым операциям поиска, что обрушивает FPS с 120 до 15.

### Правильный паттерн кеширования:
```lua
-- Кешируем один раз на уровне файла (file scope):
local MAT_HEART = Material("icon16/heart.png", "smooth noclamp")
local MAT_SHIELD = Material("icon16/shield.png", "smooth noclamp")
local MAT_GRADIENT = Material("gui/gradient_down")

-- В хуке отрисовки используем кешированную переменную:
hook.Add("HUDPaint", "my_hud/draw", function()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(MAT_HEART)
	surface.DrawTexturedRect(32, 32, 16, 16)
end)
```

---

## 4. Встроенные графические ассеты Garry's Mod

В каждом клиенте GMod уже есть сотни готовых ресурсов, не требующих скачивания через FastDL:

### 1. Silkicons (`materials/icon16/*.png`)
* Более 1000 иконок 16x16 (набор FamFamFam Silk).
* Браузер иконок прямо в игре: консольная команда `derma_icon_browser`.
* Популярные иконки для RP-интерфейсов:
  - `icon16/user.png` — профиль / гражданин
  - `icon16/heart.png` — здоровье
  - `icon16/shield.png` — броня
  - `icon16/drink.png` — вода / напитки
  - `icon16/money.png` — валюта / экономика
  - `icon16/box.png` — склад / инвентарь
  - `icon16/lock.png` — запертая дверь
  - `icon16/wrench.png` — ремонт / инженер

### 2. Градиенты движка (`materials/gui/`)
* `gui/gradient_down` — вертикальный градиент (сверху вниз)
* `gui/gradient_up` — вертикальный градиент (снизу вверх)
* `gui/gradient` — горизонтальный градиент (слева направо)

### 3. Флаги (`materials/flags16/*.png`)
* Иконки флагов стран 16x11 (например, `flags16/ru.png`, `flags16/us.png`).

---

## 5. Адаптивное масштабирование под разрешение экрана

Никаких захардкоженных размеров в пикселях для корневых окон.

```lua
local function scaleW(pixelsAt1080p)
	return math.Round((ScrW() / 1920) * pixelsAt1080p)
end

local function scaleH(pixelsAt1080p)
	return math.Round((ScrH() / 1080) * pixelsAt1080p)
end

-- Пересоздание шрифтов при смене разрешения экрана:
hook.Add("OnScreenSizeChanged", "my_addon/refresh_resolution", function()
	-- Обновляем шрифты с новым коэффициентом ScrH() / 1080
end)
```
