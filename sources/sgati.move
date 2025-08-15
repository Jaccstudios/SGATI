module sgati_addr::sgati {

    use sui::object;
    use sui::transfer;
    use sui::tx_context;
    use sui::clock;
    use std::string;
    use std::option;
    use std::vector;

    // === Errores ===
    const E_ESTADO_ACTUAL_INCORRECTO: u64 = 1;
    const E_ACTIVO_YA_ESTA_RETIRADO: u64 = 2;
    const E_ACTIVO_NO_ESTA_EN_MANTENIMIENTO: u64 = 3;

    // === Objetos y Estructuras ===

    /// Un objeto "Capability" que representa la propiedad o el rol de administrador del módulo.
    /// Se crea una sola vez cuando el módulo es publicado.
    public struct SgatiAdminCap has key {
        id: object::UID,
    }

    /// Estructura para almacenar los detalles de un mantenimiento.
    /// No tiene `key` porque siempre vivirá dentro de un objeto `Activo`.
    public struct RegistroMantenimiento has store, drop {
        tipo_mantenimiento: string::String, // "preventivo" o "correctivo"
        descripcion: string::String,
        tecnico: string::String,
        fecha: u64, // timestamp en ms
    }

    /// Objeto principal que representa un Activo de TI.
    public struct Activo has key, store {
        id: object::UID,
        tipo_activo: string::String,
        modelo: string::String,
        numero_serie: string::String,
        fecha_registro: u64,
        ubicacion: string::String,
        asignado_a: option::Option<string::String>,
        estado: string::String, // "en_almacen", "asignado", "en_mantenimiento", "retirado"
        registros_mantenimiento: vector<RegistroMantenimiento>,
        propietario: address,
    }

    /// Función `init`: se ejecuta una sola vez al publicar el módulo.
    fun init(ctx: &mut tx_context::TxContext) {
        // Crea el objeto de capacidad de administrador y lo transfiere a quien publica el contrato.
        transfer::transfer(SgatiAdminCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx))
    }

    // === Funciones de Entrada (Entrypoints) ===

    /// Crea un nuevo objeto `Activo`.
    public fun crear_activo(
        tipo_activo: string::String,
        modelo: string::String,
        numero_serie: string::String,
        ubicacion: string::String,
        ctx: &mut tx_context::TxContext,
        clock: &clock::Clock,
    ) {
        let nuevo_activo = Activo {
            id: object::new(ctx),
            tipo_activo,
            modelo,
            numero_serie,
            fecha_registro: clock::timestamp_ms(clock),
            ubicacion,
            asignado_a: option::none(),
            estado: string::utf8(b"en_almacen"),
            registros_mantenimiento: vector::empty(),
            propietario: tx_context::sender(ctx),
        };
        transfer::transfer(nuevo_activo, tx_context::sender(ctx));
    }

    /// Asigna un activo a un empleado.
    public fun asignar_activo(
        activo: &mut Activo,
        empleado_id: string::String,
        nueva_ubicacion: string::String,
    ) {
        assert!(activo.estado == string::utf8(b"en_almacen"), E_ESTADO_ACTUAL_INCORRECTO);
        assert!(activo.estado != string::utf8(b"retirado"), E_ACTIVO_YA_ESTA_RETIRADO);

        activo.ubicacion = nueva_ubicacion;
        activo.asignado_a = option::some(empleado_id);
        activo.estado = string::utf8(b"asignado");
    }

    /// Envía un activo a mantenimiento.
    public fun enviar_a_mantenimiento(
        activo: &mut Activo,
        ubicacion_taller: string::String,
    ) {
        assert!(activo.estado != string::utf8(b"retirado"), E_ACTIVO_YA_ESTA_RETIRADO);

        activo.ubicacion = ubicacion_taller;
        activo.asignado_a = option::none();
        activo.estado = string::utf8(b"en_mantenimiento");
    }

    /// Registra un mantenimiento completado y regresa el activo a almacén.
    public fun registrar_mantenimiento_realizado(
        activo: &mut Activo,
        tipo_mantenimiento: string::String,
        descripcion: string::String,
        tecnico: string::String,
        nueva_ubicacion_almacen: string::String,
        clock: &clock::Clock,
    ) {
        assert!(activo.estado == string::utf8(b"en_mantenimiento"), E_ACTIVO_NO_ESTA_EN_MANTENIMIENTO);

        let registro = RegistroMantenimiento {
            tipo_mantenimiento,
            descripcion,
            tecnico,
            fecha: clock::timestamp_ms(clock),
        };

        vector::push_back(&mut activo.registros_mantenimiento, registro);
        activo.ubicacion = nueva_ubicacion_almacen;
        activo.estado = string::utf8(b"en_almacen");
    }

    /// Retira un activo del ciclo de vida útil.
    public fun retirar_activo(activo: &mut Activo) {
        assert!(activo.estado != string::utf8(b"retirado"), E_ACTIVO_YA_ESTA_RETIRADO);
        activo.estado = string::utf8(b"retirado");
        activo.asignado_a = option::none();
    }
}