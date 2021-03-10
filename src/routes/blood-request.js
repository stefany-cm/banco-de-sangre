const { request } = require('express');
const express = require('express');
const router = express.Router();

const pool = require('../database');

router.get('/', async (req, res) => {
    const blood_requests = await pool.query('SELECT * FROM vw_get_solicitudes');
    res.render('blood-request/list', { blood_requests: blood_requests });
})

router.get('/add', async (req, res) => {
    const blood_group = await pool.query('SELECT grupo_sanguineo.pk_grupo_sanguineo AS id, CONCAT(grupo_sanguineo.marcador_grupo_sanguineo, fn_convert_rh_grupo_sanguineo(grupo_sanguineo.rh_grupo_sanguineo)) AS grupo_sangre FROM grupo_sanguineo');
    const blood_bank = await pool.query('SELECT pk_banco_sangre AS id, razon_social_banco_sangre AS nombre FROM banco_sangre WHERE banco_sangre.estado_banco_sangre != \'I\'');

    res.render('blood-request/add', { blood_group, blood_bank });
});

router.post('/add', async (req, resp) => {
    const { cantidad_sangre, fecha_finalizacion, sexo, grupo_sanguineo, banco_sangre} = req.body;
    const request_blood = {
        cantidad_sangre,
        fecha_finalizacion,
        sexo,
        grupo_sanguineo,
        banco_sangre
    }
    console.log(request_blood)
    await pool.query('CALL pd_registrar_solicitud_sangre (' + cantidad_sangre + ', \'' + fecha_finalizacion + '\', \'' + sexo + '\', ' + grupo_sanguineo + ', ' + banco_sangre + ', ' + 1 + ');');
    resp.redirect('/blood-request');
});

router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    await pool.query('UPDATE solicitud_sangre SET estado_solicitud_sangre = \'X\' WHERE pk_solicitud_sangre = ' + id + '')
    res.redirect('/blood-request')
});

router.get('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const blood_group = await pool.query('SELECT grupo_sanguineo.pk_grupo_sanguineo AS id, CONCAT(grupo_sanguineo.marcador_grupo_sanguineo, fn_convert_rh_grupo_sanguineo(grupo_sanguineo.rh_grupo_sanguineo)) AS grupo_sangre FROM grupo_sanguineo');
    const blood_bank = await pool.query('SELECT pk_banco_sangre AS id, razon_social_banco_sangre AS nombre FROM banco_sangre WHERE banco_sangre.estado_banco_sangre != \'I\'');
    const blood_request = await pool.query('SELECT * FROM vw_get_solicitudes WHERE id = ' + id + '')
    console.log(blood_request[0]);
    res.render('blood-request/edit', {blood_group, blood_bank, blood_request: blood_request[0]});
});

router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { cantidad_sangre, fecha_finalizacion, sexo, grupo_sanguineo, banco_sangre } = req.body;
    const request_blood = {
        cantidad_sangre,
        fecha_finalizacion,
        sexo,
        grupo_sanguineo,
        banco_sangre
    }
    console.log(request_blood);
    await pool.query('CALL `pd_update_solicitud_sangre`(' + id + ', ' + cantidad_sangre + ', \'' + fecha_finalizacion + '\', \'' + sexo + '\', ' + grupo_sanguineo + ', ' + banco_sangre + ');');
    res.redirect('/blood-request');
});

router.get('/donation/:id', async (req, res) => {
    const { id } = req.params;
    res.render('blood-request/add-donation', {id});
});

router.post('/donation/add/:id', async (req, res) => {
    const { id } = req.params;
    const { cantidad_sangre } = req.body;
    const request_blood = {
        cantidad_sangre
    }
    console.log(request_blood);
    await pool.query('CALL `pd_registrar_donacion`('+cantidad_sangre+', '+ id +')');
    res.redirect('/blood-request');
});

module.exports = router;