import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import {
  Box,
  Container,
  CssBaseline,
  ThemeProvider,
  Typography,
  createTheme,
  Link,
} from "@mui/material";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
  },
]);

const theme = createTheme({
  // palette: { mode: "dark" },
  colorSchemes: {
    dark: true,
  },
  typography: {
    fontFamily: "'Playpen Sans', sans-serif",
  },
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Box
        sx={{ display: "flex", flexDirection: "column", minHeight: "100vh" }}
      >
        <RouterProvider router={router} />
        <Box component="footer" sx={{ mt: "auto", py: 2 }}>
          <Container maxWidth="sm" sx={{ textAlign: "center" }}>
            <Typography variant="body2" color="textSecondary">
              created by
              <Link
                href="https://github.com/dipamsen"
                target="_blank"
                rel="noreferrer"
                sx={{ ml: 1 }}
              >
                dipamsen
              </Link>
            </Typography>
          </Container>
        </Box>
      </Box>
    </ThemeProvider>
  </React.StrictMode>
);
