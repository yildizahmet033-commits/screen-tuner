# Screen Tuner

**English** | [Türkçe](#türkçe)

A small root module that adds a **screen saturation slider** and a **resolution switcher** to your phone, controlled from a WebUI page inside your root manager. No APK, no system files replaced, no changes until you pick a value.

> **Status:** tested only on Xiaomi 12 Pro (zeus) with Evolution X 12 (Android 17) and BakaSU. Everything else is experimental.

## Features

- **Saturation 50–200 %** in 5 % steps, applied live while you drag, re-applied on every boot
- **Resolution presets** calculated from your own panel: native, 1440p, 1080p and 720p (only those your panel can do)
- **Text and icon size are kept**: density is scaled together with the resolution
- **Automatic revert**: a resolution that is not confirmed within 15 seconds is undone, also after a reboot
- **Restore everything** button, and clean-up when the module is removed
- English and Turkish, light and dark theme

## Requirements

- Root with a manager that supports module WebUI (KernelSU and its forks, such as BakaSU; APatch should work too)
- The Magisk app has no WebUI. You need a separate WebUI app, or use the script below
- Android 12 or newer recommended

## Installation

1. Download the zip from [Releases](https://github.com/yildizahmet033-commits/screen-tuner/releases).
2. Install it in your root manager and reboot.
3. Open the module's WebUI and choose your values.

## Command line

```sh
su
ctl=/data/adb/modules/screen-tuner/ctl.sh
sh $ctl status
sh $ctl sat 150                  # 50-200
sh $ctl res 1080 2400 420        # width height density
sh $ctl confirm                  # keep it, otherwise it reverts in 15 s
sh $ctl revert                   # undo the unconfirmed change now
sh $ctl reset                    # restore everything
```

## Known limits

- Vendor ROMs with their own color engine (HyperOS, One UI, ColorOS) may ignore or override the saturation.
- Changing the system color mode can reset the saturation until the next boot or until you move the slider.
- Other apps that control saturation with root can override the value.
- The panel itself keeps running at its native resolution; a lower preset only lowers the rendered resolution. Battery impact was not measured.
- Some games and banking apps may react to a changed resolution.
- Only the main display is handled. Foldables are untested.

## If something goes wrong

Wait 15 seconds, or run `adb shell wm size reset` and `adb shell wm density reset`. Disabling the module and rebooting stops the saturation from being applied; a confirmed resolution stays until you reset it or remove the module.

Use at your own risk.

---

# Türkçe

Telefonuna **ekran doygunluğu sürgüsü** ve **çözünürlük seçici** ekleyen küçük bir root modülü. Root yöneticisinin içinde açılan bir sayfadan kullanılır. APK kurmaz, sistem dosyası değiştirmez, sen bir değer seçmeden hiçbir şeyi değiştirmez.

> **Durum:** Yalnızca Xiaomi 12 Pro (zeus), Evolution X 12 (Android 17) ve BakaSU ile denendi. Diğer her şey deneyseldir.

## Özellikler

- **%50–%200 doygunluk**, 5'er adımla; kaydırırken anında uygulanır, her açılışta yeniden uygulanır
- Kendi ekranından hesaplanan **çözünürlük seçenekleri**: ekranın kendi çözünürlüğü, 1440p, 1080p ve 720p (yalnızca ekranının yapabildikleri)
- **Yazı ve simge boyu korunur**: yoğunluk, çözünürlükle birlikte ölçeklenir
- **Kendiliğinden geri dönme**: 15 saniye içinde onaylanmayan çözünürlük geri alınır, telefon yeniden başlasa bile
- **Her şeyi ilk hâline döndür** düğmesi ve modül kaldırılınca temizlik
- Türkçe ve İngilizce, açık ve koyu tema

## Gerekenler

- Modül arayüzünü destekleyen bir root yöneticisi (KernelSU ve BakaSU gibi türevleri; APatch'te de çalışması beklenir)
- Magisk uygulamasında modül arayüzü yoktur. Ayrı bir arayüz uygulaması ya da aşağıdaki komutlar gerekir
- Android 12 veya üstü önerilir

## Kurulum

1. Zip dosyasını [Releases](https://github.com/yildizahmet033-commits/screen-tuner/releases) sayfasından indir.
2. Root yöneticinden kur ve yeniden başlat.
3. Modülün arayüzünü aç, değerlerini seç.

## Komut satırı

```sh
su
ctl=/data/adb/modules/screen-tuner/ctl.sh
sh $ctl status
sh $ctl sat 150                  # 50-200
sh $ctl res 1080 2400 420        # genişlik yükseklik yoğunluk
sh $ctl confirm                  # kalsın; yoksa 15 saniyede geri döner
sh $ctl revert                   # onaylanmamış değişikliği hemen geri al
sh $ctl reset                    # her şeyi ilk hâline döndür
```

## Bilinen sınırlar

- Kendi renk sistemi olan üretici ROM'ları (HyperOS, One UI, ColorOS) doygunluğu yok sayabilir ya da ezebilir.
- Sistemin renk kipini değiştirmek, sonraki açılışa ya da sürgüyü oynatana kadar doygunluğu sıfırlayabilir.
- Root ile doygunluğu yöneten başka uygulamalar değeri değiştirebilir.
- Panel hep kendi çözünürlüğünde çalışır; düşük seçenek yalnızca çizilen görüntüyü küçültür. Pile etkisi ölçülmedi.
- Bazı oyunlar ve banka uygulamaları değişen çözünürlükten etkilenebilir.
- Yalnızca ana ekran desteklenir. Katlanabilir cihazlarda denenmedi.

## Sorun çıkarsa

15 saniye bekle ya da `adb shell wm size reset` ve `adb shell wm density reset` komutlarını çalıştır. Modülü kapatıp yeniden başlatınca doygunluk artık uygulanmaz; onaylanmış çözünürlük, sen sıfırlayana ya da modülü kaldırana kadar kalır.

Kullanım sorumluluğu sana aittir.
