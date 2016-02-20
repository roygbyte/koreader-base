local BB = require("ffi/blitbuffer")
local Png = require("ffi/png")

describe("Png module", function()
    it("should write bitmap to png file", function()
        local re, ok
        local fn = os.tmpname()
        local bb = BB.new(400, 600, BB.TYPE_BBRGB32)
        bb:setPixel(0, 0, BB.ColorRGB32(128, 128, 128, 0))
        bb:setPixel(200, 300, BB.ColorRGB32(10, 128, 205, 50))
        bb:setPixel(400, 100, BB.ColorRGB32(120, 28, 25, 255))
        ok = Png.encodeToFile(fn, bb)
        assert.are.same(ok, true)

        ok, re = Png.decodeFromFile(fn)
        assert.are.same(ok, true)
        bb2 = BB.new(re.width, re.height, BB.TYPE_BBRGB32, re.data)
        local c = bb2:getPixel(0, 0)
        assert.are.same({0x80, 0x80, 0x80, 0}, {c.r, c.g, c.b, c.alpha})
        c = bb2:getPixel(200, 200)
        assert.are.same({0, 0, 0, 0}, {c.r, c.g, c.b, c.alpha})
        c = bb2:getPixel(200, 300)
        assert.are.same({10, 128, 205, 50}, {c.r, c.g, c.b, c.alpha})
        c = bb2:getPixel(400, 100)
        assert.are.same({120, 28, 25, 255}, {c.r, c.g, c.b, c.alpha})
        os.remove(fn)
    end)
end)