#!/bin/bash

# Parola üretme fonksiyonu
generate_password() {
    local length=$1
    # openssl rand komutu ile base64 string üret ve kes
    openssl rand -base64 48 | cut -c1-"$length"
}

# Seçilen parolayı dosyaya kaydet
save_selected_password() {
    local password=$1
    local file="secili_parolalar.txt"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp - Seçtiğiniz şifre: $password" >> "$file"
    echo "✅ Seçilen parola '$file' dosyasına kaydedildi."
}

# Parolaları listele
show_passwords() {
    local passwords=("$@")
    echo ""
    echo "Oluşturulan parolalar:"
    for i in "${!passwords[@]}"; do
        echo "$((i+1))) ${passwords[$i]}"
    done
}

# Kullanıcıya seçim yaptır
ask_user_choice() {
    local passwords=("$@")

    while true; do
        read -rp $'\nAralarında seçtiğiniz var mı? (e/h): ' choice
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

        if [[ "$choice" != "e" && "$choice" != "h" ]]; then
            echo "Lütfen 'e' (evet) veya 'h' (hayır) girin."
            continue
        fi

        if [[ "$choice" == "e" ]]; then
            read -rp "Seçtiğiniz şifreyi numara ile mi (örnek: 2) yoksa tam metin olarak mı gireceksiniz? (n/m): " mode
            mode=$(echo "$mode" | tr '[:upper:]' '[:lower:]')

            if [[ "$mode" == "n" ]]; then
                read -rp "Lütfen seçtiğiniz parolanın numarasını girin: " num
                if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#passwords[@]} )); then
                    echo "Geçersiz numara. Tekrar deneyin."
                    continue
                fi
                selected="${passwords[$((num-1))]}"
                save_selected_password "$selected"
                return 0
            elif [[ "$mode" == "m" ]]; then
                read -rp "Lütfen tam parolayı yapıştırın: " entered
                found=false
                for p in "${passwords[@]}"; do
                    [[ "$p" == "$entered" ]] && found=true
                done
                if $found; then
                    save_selected_password "$entered"
                    return 0
                else
                    read -rp "Girdiğiniz parola listede yok. Yine de kaydetmek istiyor musunuz? (e/h): " confirm
                    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
                    if [[ "$confirm" == "e" ]]; then
                        save_selected_password "$entered"
                        return 0
                    else
                        echo "Seçim kaydedilmedi. Yeni parolalar oluşturulacak."
                        return 1
                    fi
                fi
            else
                echo "Geçersiz seçim. 'n' veya 'm' girin."
            fi
        else
            return 1
        fi
    done
}

# Ana program
echo "🔑 Parola Üreticiye Hoş Geldiniz! (Bash sürümü)"
echo ""

read -rp "Lütfen üretilecek parolanın uzunluğunu girin: " length
if ! [[ "$length" =~ ^[0-9]+$ ]] || (( length <= 0 )); then
    echo "Hata: Pozitif bir sayı girin."
    exit 1
fi

read -rp "Kaç adet parola üretmek istersiniz? (varsayılan 3): " count
if [[ -z "$count" ]]; then count=3; fi
if ! [[ "$count" =~ ^[0-9]+$ ]] || (( count <= 0 )); then
    echo "Hata: Pozitif bir sayı girin."
    exit 1
fi

while true; do
    passwords=()
    for ((i=0; i<count; i++)); do
        passwords+=("$(generate_password "$length")")
    done

    show_passwords "${passwords[@]}"

    if ask_user_choice "${passwords[@]}"; then
        break
    else
        echo ""
        echo "Yeni parolalar oluşturuluyor..."
    fi
done

echo ""
echo "Program sonlandırıldı. İyi günler!"
