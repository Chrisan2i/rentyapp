// lib/core/constants/terms_and_conditions.dart

/// Términos y Condiciones de uso de la plataforma Renty.
/// Se calcula la fecha de última actualización al cargar la aplicación.
final String rentyTermsAndConditions = '''
**TÉRMINOS Y CONDICIONES DE USO – PLATAFORMA RENTY**

**1. Definiciones**
**Renty**: Plataforma digital que facilita el arrendamiento de bienes muebles entre particulares.
**Arrendador**: Usuario que ofrece un bien en alquiler a través de Renty.
**Arrendatario**: Usuario que toma en alquiler un bien ofrecido en Renty.
**Bien**: Objeto tangible objeto del arrendamiento.

**2. Objeto y Alcance**
Estos Términos y Condiciones regulan el uso de la plataforma Renty y constituyen el acuerdo legal entre Renty, el Arrendador y el Arrendatario. Al confirmar cualquier transacción, ambas partes aceptan estar obligadas por estos términos.

**3. Registro y Cuenta de Usuario**
3.1. Para utilizar Renty, el usuario debe registrarse con datos veraces y mantenerlos actualizados.
3.2. Cada cuenta es personal e intransferible; el usuario es responsable de mantener la confidencialidad de su contraseña.

**4. Proceso de Alquiler**
4.1. El Arrendatario realiza la solicitud indicando periodo y condiciones.
4.2. El Arrendador acepta o rechaza la solicitud en un plazo máximo de 24 horas.
4.3. Tras la aceptación, el Arrendatario paga el importe total y, en su caso, la garantía.
4.4. Renty intermedia el pago y emite un comprobante digital.

**5. Obligaciones del Arrendador**
5.1. Entregar el bien en la fecha, hora y lugar acordados.
5.2. Garantizar que el bien se encuentra en condiciones óptimas de uso.
5.3. Atender cualquier incidencia razonable durante el periodo de alquiler.

**6. Obligaciones del Arrendatario**
6.1. Pagar el precio del alquiler y depósito de garantía de forma anticipada.
6.2. Utilizar el bien con cuidado y conforme a su finalidad.
6.3. Devolver el bien en la fecha, hora y lugar pactados y en el mismo estado salvo desgaste natural.

**7. Depósito de Garantía y Daños**
7.1. El depósito se retiene hasta la finalización y devolución satisfactoria del bien.
7.2. En caso de daño, pérdida o incumplimiento, el Arrendador podrá retener total o parcialmente el depósito.
7.3. Si los costos de reparación exceden el depósito, el Arrendatario se compromete a cubrir la diferencia.

**8. Cancelación y Penalizaciones**
8.1. El Arrendatario puede cancelar sin penalización hasta 48 horas antes del inicio.
8.2. Cancelaciones tardías o no presentación pueden acarrear una penalización del 50% del precio.

**9. Seguros y Responsabilidad**
9.1. Renty no ofrece seguro automático; ambas partes pueden contratar cobertura adicional.
9.2. El Arrendador es responsable por defectos ocultos del bien.
9.3. El Arrendatario es responsable por daños causados por uso negligente.

**10. Disputas y Mediación**
10.1. Cualquier discrepancia se someterá primero a mediación interna de Renty.
10.2. Si no se resuelve, las partes podrán acudir a arbitraje o a la vía judicial.

**11. Protección de Datos y Privacidad**
11.1. Renty trata datos personales de acuerdo con su Política de Privacidad.
11.2. Los usuarios consienten el tratamiento para gestionar comunicaciones y transacciones.

**12. Modificaciones de los Términos**
Renty podrá actualizar estos términos en cualquier momento. Los cambios se comunicarán en la plataforma y entrarán en vigor tras su publicación.

**13. Ley Aplicable y Jurisdicción**
Estos Términos se rigen por las leyes de la República Bolivariana de Venezuela. Para cualquier disputa, las partes se someten a los tribunales competentes de la ciudad de Caracas.

**14. Aceptación Digital**
Al confirmar el pago, Arrendador y Arrendatario aceptan electrónicamente estos Términos con validez legal equivalente a un documento físico firmado.

**Fecha de última actualización:** ${DateTime.now().toIso8601String().split('T').first}
''';
