const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const connectDB = require('./config');
const authRoutes = require('./routes/auth');
const bantuanRoutes = require('./routes/bantuan');
const edukasiRoutes = require('./routes/edukasi');
const pengajuanRoutes = require('./routes/pengajuan');

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/bantuan', bantuanRoutes);
app.use('/api/edukasi', edukasiRoutes);
app.use('/api/pengajuan', pengajuanRoutes);

app.listen(process.env.PORT, () =>
  console.log(`Server running on port ${process.env.PORT}`)
);