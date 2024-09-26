import {
  AppBar,
  Button,
  Switch,
  Toolbar,
  Typography,
  useColorScheme,
  useMediaQuery,
} from "@mui/material";
import MenuIcon from "@mui/icons-material/MenuBook";

export default function Header() {
  const { mode, setMode } = useColorScheme();
  const preferredDark = useMediaQuery("(prefers-color-scheme: dark)");
  if (!mode) {
    return null;
  }

  const isDark = mode === "dark" || (mode === "system" && preferredDark);
  return (
    <AppBar position="static">
      <Toolbar>
        <MenuIcon sx={{ mr: 2 }} />
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
          IIT Kharagpur UG Curriculum
        </Typography>
        <Button color="inherit" href="/" sx={{ mr: 1 }}>
          Home
        </Button>
        <Button color="inherit" href="/cgpa">
          CGPA
        </Button>
        <Switch
          value={isDark}
          onChange={(_, value) => {
            setMode(value ? "dark" : "light");
          }}
        />
      </Toolbar>
    </AppBar>
  );
}
