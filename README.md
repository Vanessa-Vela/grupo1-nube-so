# Grupo 1 — Nube y Linux minimal

Material de la exposición del Grupo 1 (Darwin, Vanessa, Karina, Jordan).

## 📄 Cheat sheet completo
Costos, SLA, hardening, Linux minimal, AWS CLI y Terraform en una sola hoja:
**PEGA_AQUI_EL_ENLACE_DEL_CHEAT_SHEET**

## 📦 Archivos de este repositorio
| Archivo | Para qué sirve |
|---|---|
| `main.tf` | Crea con Terraform una instancia Ubuntu 24.04 t3.micro con nginx y hardening |
| `hardening.sh` | Endurece un Ubuntu 24.04 en 5 pasos (SSH, firewall, fail2ban) |

## 🚀 Repetir la demo en casa
```bash
git clone https://github.com/TU_USUARIO/grupo1-nube-so.git
cd grupo1-nube-so
aws configure                 # tus llaves de AWS, región us-east-1
terraform init
terraform apply               # al final muestra ip_publica
# abre http://<ip_publica> en el navegador
terraform destroy             # ¡no olvides borrar todo!
```

## 🔒 Endurecer un servidor que ya tienes
```bash
ssh -i grupo1.pem ubuntu@<IP>
curl -O https://raw.githubusercontent.com/TU_USUARIO/grupo1-nube-so/main/hardening.sh
chmod +x hardening.sh && sudo ./hardening.sh
```

> ⚠️ Destruye todo al terminar para no pagar. Nunca subas tu `.pem` ni `terraform.tfstate` a GitHub.
